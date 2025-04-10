//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

import PhotosUI

final class PopupViewController: BaseViewController {
    var viewModel = PopupViewModel()
    
    var completion: ((Any) -> Void)?
    var pickerCompletion: ((UIImage) -> Void)?
    
    private var popupView = BasePopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        
        popupView = getPopupView()
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        
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

extension PopupViewController {
    private func getPopupView() -> BasePopupView {
        guard let popupType = viewModel.popupType else { return BasePopupView() }
        switch popupType {
        case .alert:
            guard let alertType = viewModel.alertType else { return BasePopupView() }
            let alertView = AlertPopupView(type: alertType)
            alertView.confirmButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    completion?(())
                    hidePopup()
                }, for: .touchUpInside
            )
            return alertView
            
        case .certification:
            let certificationPopupView = CertificationPopupView()
            certificationPopupView.setExtraInfo(todoInfo: viewModel.todoInfo)
            
            pickerCompletion = { [weak self] image in
                guard let self else { return }
                certificationPopupView.uploadImage(image: image)
                viewModel.uploadImage(image: image)
            }
            
            [certificationPopupView.galleryButton, certificationPopupView.cameraButton].forEach { button in
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
            
            certificationPopupView.certificationButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    Task {
                        try await self.viewModel.certifyTodo()
                        await MainActor.run {
                            self.hidePopup()
                        }
                    }
                }, for: .touchUpInside
            )
            
            certificationPopupView.certificationTextView.delegate = self
            return certificationPopupView
            
        case .certificationInfo:
            guard let todoInfo = viewModel.todoInfo else { return BasePopupView() }
            return CertificationInfoPopupView(todoInfo: todoInfo)
            
        case .rejectReason:
            let rejectReasonPopupView = RejectReasonPopupView()
            rejectReasonPopupView.rejectReasonTextView.delegate = self
            rejectReasonPopupView.rejectReasonButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let rejectReason = viewModel.stringContent else { return }
                    completion?(rejectReason)
                    hidePopup()
                }, for: .touchUpInside
            )
            return rejectReasonPopupView
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
}

// MARK: - about gallery
extension PopupViewController: PHPickerViewControllerDelegate {
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
                self.pickerCompletion?(pngImage)
            }
        }
    }
}

// MARK: - about camera
extension PopupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        pickerCompletion?(pngImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - about keyboard
extension PopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        guard let textView = textView as? DogetherTextView else { return false }
        let currentText = textView.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        
        return updatedText.count <= textView.type.maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? DogetherTextView else { return }
        textView.updateTextInfo()
        viewModel.setStringContent(textView.text)
        
        if let popupView = popupView as? CertificationPopupView, textView.text.count > 0 {
            popupView.certificationButton.setButtonStatus(status: .enabled)
        }
        if let popupView = popupView as? RejectReasonPopupView, textView.text.count > 0 {
            popupView.rejectReasonButton.setButtonStatus(status: .enabled)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOn()
        
        if let popupView = popupView as? CertificationPopupView ?? popupView as? RejectReasonPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOff()
        
        if let popupView = popupView as? CertificationPopupView ?? popupView as? RejectReasonPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        }
        return true
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
