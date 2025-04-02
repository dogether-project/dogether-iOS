//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

final class PopupViewController: BaseViewController {
    var viewModel = PopupViewModel()
    
    var completion: ((Any) -> Void)?
    
    private var cameraManager: CameraManager!
    private var galleryManager: GalleryManager!
    
    private var popupView = BasePopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        
        guard let popupType = viewModel.popupType else { return }
        switch popupType {
        case .alert:
            guard let alertType = viewModel.alertType else { return }
            let alertView = AlertPopupView(type: alertType)
            alertView.confirmButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    completion?(())
                    hidePopup()
                }, for: .touchUpInside
            )
            popupView = alertView
            
        case .certification:
            guard let todoInfo = viewModel.todoInfo else { return }
            let certificationPopupView = CertificationPopupView(todoInfo: todoInfo, completeAction: { certificationContent in
                Task { @MainActor in
                    try await self.viewModel.certifyTodo(todoId: todoInfo.id, certificationContent: certificationContent)
                    self.hidePopup()
                }
            })
            
            certificationPopupView.cameraManager = CameraManager(viewController: self)
            certificationPopupView.galleryManager = GalleryManager(viewController: self)
            
            let completion = { self.uploadImage(view: certificationPopupView, image: $0) }
            cameraManager.completion = completion
            galleryManager.completion = completion
            popupView = certificationPopupView
            
        case .certificationInfo:
            guard let todoInfo = viewModel.todoInfo else { return }
            popupView = CertificationInfoPopupView(todoInfo: todoInfo)
            
        case .rejectReason:
            let rejectReasonPopupView = RejectReasonPopupView()
            rejectReasonPopupView.rejectReasonButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let rejectReason = viewModel.stringContent else { return }
                    completion?(rejectReason)
                    hidePopup()
                }, for: .touchUpInside
            )
            popupView = rejectReasonPopupView
        }
        popupView.delegate = self
    }
    
    override func configureHierarchy() {
        [popupView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        popupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension PopupViewController: PopupDelegate {
    func hidePopup() {
        coordinator?.hidePopup()
    }
}

extension PopupViewController {
    @objc private func dismissPopup() {
        hidePopup()
    }
    
    private func uploadImage(view certificationPopupView: CertificationPopupView, image: UIImage?) {
        guard let image else { return }
        certificationPopupView.uploadImage(image: image)
        viewModel.uploadImage(image: image)
    }
}
