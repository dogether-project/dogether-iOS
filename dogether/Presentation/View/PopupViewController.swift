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
    var completeAction: (() -> Void)?
    
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
        
        configureSubView()
    }
    
    override func configureView() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        guard let popupType else { return }
        switch popupType {
        case .certification:
            popupView = CertificationPopupView(completeAction: completeAction ?? { })
        case .certificationInfo:
            break   // TODO: 추후 CertificationInfoPopupView 추가
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
            $0.height.equalTo(popupType?.popupHeight ?? 0)
        }
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    private func configureSubView() {
        cameraManager = CameraManager(viewController: self)
        galleryManager = GalleryManager(viewController: self)
        
        if let popupView = self.popupView as? CertificationPopupView {
            popupView.cameraManager = cameraManager
            popupView.galleryManager = galleryManager
            
            let completion = {
                self.uploadImage(view: popupView, image: $0)
                // TODO: 추후 S3Manager로 이동
//                private func uploadImageToS3(image: UIImage) {
//                    Task {
//                        let request: PresignedUrlRequest = PresignedUrlRequest(todoId: 0, uploadFileTypes: [.image])
//                        let response: PresignedUrlResponse = try await NetworkService.shared.request(
//                            S3.presignedUrls(presignedUrlRequest: request)
//                        )
//                    }
//                }
            }
            cameraManager.completion = completion
            galleryManager.completion = completion
        }
    }
    
    private func uploadImage(view certificationPopupView: CertificationPopupView, image: UIImage?) {
        guard let image else { return }
        certificationPopupView.uploadImage(image: image)
    }
}
