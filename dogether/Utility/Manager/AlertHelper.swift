//
//  AlertHelper.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit

class AlertHelper  {
    static func alert(on viewController: UIViewController, alertType: AlertTypes, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: alertType.title, message: alertType.message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: alertType.buttonText, style: .default, handler: { _ in
            okAction?()
        })
        
        let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        viewController.present(alert, animated: true)
    }
}
