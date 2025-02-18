//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import Foundation
import UIKit
import SnapKit

final class PopupViewController: BaseViewController {
    var popupType: PopupTypes?
    var todoInfo: TodoInfo?
    var completeAction: ((String) -> Void)?
    
    private var cameraManager: CameraManager!
    private var galleryManager: GalleryManager!
    
    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        return view
    }()
    
    private var popupView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        guard let popupType else { return }
        switch popupType {
        case .certification:
            popupView = CertificationPopupView(completeAction: completeAction ?? { _ in })
            
            cameraManager = CameraManager(viewController: self)
            galleryManager = GalleryManager(viewController: self)
            
            if let popupView = popupView as? CertificationPopupView {
                popupView.cameraManager = cameraManager
                popupView.galleryManager = galleryManager
                
                let completion = { image in
                    self.uploadImage(view: popupView, image: image)
                    Task { @MainActor in
                        let imageUrl = try await S3Manager.shared.uploadImage(image: image)
                        // TODO: imageUrl을 viewModel에 저장, 인증하기 API 호출할 때 request에 넣어줘야 함
                    }
                }
                cameraManager.completion = completion
                galleryManager.completion = completion
            }
        case .certificationInfo:
            guard let todoInfo else { return }
            popupView = CertificationInfoPopupView(todoInfo: todoInfo)
        case .rejectReason:
            popupView = RejectReasonPopupView(completeAction: completeAction ?? { _ in })
        }
    }
    
    override func configureHierarchy() {
        [backgroundView, popupView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popupView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
        }
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    private func uploadImage(view certificationPopupView: CertificationPopupView, image: UIImage?) {
        guard let image else { return }
        certificationPopupView.uploadImage(image: image)
    }
}
