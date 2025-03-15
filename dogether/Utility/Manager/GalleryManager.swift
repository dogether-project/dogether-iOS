//
//  GalleryManager.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

import PhotosUI

final class GalleryManager: NSObject, PHPickerViewControllerDelegate {
    private weak var viewController: UIViewController?
    var completion: ((UIImage?) -> Void)?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        viewController?.present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { image, _ in
            DispatchQueue.main.async {
                if let uiImage = image as? UIImage,
                   let compressImage = uiImage.compressImage(),
                   let pngData = compressImage.pngData()
                {
                    let pngImage = UIImage(data: pngData)
                    self.completion?(pngImage)
                }
            }
        }
    }
}
