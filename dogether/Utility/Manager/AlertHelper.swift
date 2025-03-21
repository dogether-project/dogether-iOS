//
//  AlertHelper.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit

class AlertHelper  {
    static func alert(on viewController: UIViewController,
                      title: String,
                      message: String?,
                      okTitle: String = "확인",
                      okAction: (() -> Void)? = nil,
                      cancelTitle: String = "취소",
                      cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { action in
            okAction?()
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
}
