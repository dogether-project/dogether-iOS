//
//  CertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit
import SnapKit

import PhotosUI

final class CertificationViewController: BaseViewController {
    var todoInfo = TodoInfo(id: 0, content: "", status: "")
    
    private let navigationHeader = NavigationHeader(title: "인증 하기")
    
    private var imageView = CertificationImageView(
        image: .cameraDosik.imageWithPadding(
            insets: UIEdgeInsets(top: 41 * 4, left: 62 * 4, bottom: 83 * 4, right: 62 * 4), backgroundColor: .grey800
        ),
        certificationContent: "인증 사진을 업로드 해주세요!"
    )
    
    private let todoContentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private var galleryButton = UIButton()
    private var cameraButton = UIButton()
    
    private func certificationButton(certificationMethod: CertificationMethods) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .grey700
        button.tag = certificationMethod.rawValue
        
        let imageView = UIImageView(image: certificationMethod.image)
        
        let label = UILabel()
        label.text = certificationMethod.title
        label.textColor = .grey300
        label.font = Fonts.body1S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        
        button.addSubview(stackView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return button
    }
    
    private let certificationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let containerView = UIView()
    
    private let containerStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let certificationButton = DogetherButton(title: "다음", status: .disabled)
    
    override func configureView() {
        todoContentLabel.attributedText = NSAttributedString(
            string: todoInfo.content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        galleryButton = certificationButton(certificationMethod: .gallery)
        cameraButton = certificationButton(certificationMethod: .camera)
        [galleryButton, cameraButton].forEach { certificationStackView.addArrangedSubview($0) }
        
        [imageView, todoContentLabel, certificationStackView].forEach { containerStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        [galleryButton, cameraButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button, let certificationMethod = CertificationMethods(rawValue: button.tag) else { return }
                    switch certificationMethod {
                    case .gallery:
                        openGallery()
                    case .camera:
                        openCamera()
                    }
                }, for: .touchUpInside
            )
        }
        
        certificationButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let certificationSupplyViewController = CertificationSupplyViewController()
                certificationSupplyViewController.todoInfo = todoInfo
                coordinator?.pushViewController(certificationSupplyViewController)
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, containerView, certificationButton].forEach { view.addSubview($0) }
        [containerStackView].forEach { containerView.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        certificationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.bottom.equalTo(certificationButton.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        containerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        certificationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

// MARK: - about gallery
extension CertificationViewController: PHPickerViewControllerDelegate {
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self,
                  let uiImage = image as? UIImage,
                  let compressImage = uiImage.compressImage(),
                  let pngData = compressImage.pngData(),
                  let pngImage = UIImage(data: pngData) else { return }
            Task { @MainActor in
                self.pickerCompletion(image: pngImage)
            }
        }
    }
}

// MARK: - about camera
extension CertificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        
        guard let uiImage = info[.originalImage] as? UIImage,
              let compressImage = uiImage.compressImage(),
              let pngData = compressImage.pngData(),
              let pngImage = UIImage(data: pngData) else { return }
        pickerCompletion(image: pngImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - completion
extension CertificationViewController {
    private func pickerCompletion(image: UIImage) {
        imageView.image = image
        imageView.updateCertificationContent()
        Task {
            // TODO: 로딩 뷰 추가
            todoInfo.certificationMediaUrl = try await S3Manager.shared.uploadImage(image: image)
            certificationButton.setButtonStatus(status: .enabled)
        }
    }
}
