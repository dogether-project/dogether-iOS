//
//  UIImageExt.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import UIKit

extension UIImage {
    func compressImage(maxSize: CGFloat = 1024, compressionQuality: CGFloat = 0.7) -> UIImage? {
        let newWidth = self.size.width > self.size.height ? maxSize : maxSize * self.size.width / self.size.height
        let newHeight = self.size.width > self.size.height ? maxSize * self.size.height / self.size.width : maxSize
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let data = resizedImage?.jpegData(compressionQuality: compressionQuality) else { return nil }
        return UIImage(data: data)
    }
}
