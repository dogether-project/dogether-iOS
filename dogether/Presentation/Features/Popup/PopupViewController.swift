//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

final class PopupViewController: BaseViewController {
    private var viewModel = PopupViewModel()
    
    var popupType: PopupTypes?
    var todoInfo: TodoInfo?
    var rejectPopupCompletion: ((String) -> Void)?
    
    private var cameraManager: CameraManager!
    private var galleryManager: GalleryManager!
    
    private var popupView = BasePopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        guard let popupType else { return }
        switch popupType {
        case .certification:
            guard let todoInfo else { return }
            popupView = CertificationPopupView(todoInfo: todoInfo, completeAction: { certificationContent in
                Task { @MainActor in
                    try await self.viewModel.certifyTodo(todoId: self.todoInfo?.id ?? 0, certificationContent: certificationContent)
                    self.hidePopup()
                }
            })
            
            cameraManager = CameraManager(viewController: self)
            galleryManager = GalleryManager(viewController: self)
            
            if let popupView = popupView as? CertificationPopupView {
                popupView.cameraManager = cameraManager
                popupView.galleryManager = galleryManager
                
                let completion = { self.uploadImage(view: popupView, image: $0) }
                cameraManager.completion = completion
                galleryManager.completion = completion
            }
        case .certificationInfo:
            guard let todoInfo else { return }
            popupView = CertificationInfoPopupView(todoInfo: todoInfo)
        case .rejectReason:
            popupView = RejectReasonPopupView()
        }
        popupView.delegate = self
        popupView.delegate?.rejectPopupCompletion = rejectPopupCompletion
    }
    
    override func configureHierarchy() {
        [popupView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        popupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
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
