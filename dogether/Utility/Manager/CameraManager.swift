//
//  CameraManager.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

final class CameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private weak var viewController: UIViewController?
    var completion: ((UIImage?) -> Void)?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        viewController?.present(picker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let uiImage = info[.originalImage] as? UIImage,
           let compressImage = uiImage.compressImage(),
            let pngData = compressImage.pngData()
        {
            let pngImage = UIImage(data: pngData)
            completion?(pngImage)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
