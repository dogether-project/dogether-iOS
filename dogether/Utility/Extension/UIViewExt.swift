//
//  UIViewExt.swift
//  dogether
//
//  Created by seungyooooong on 9/15/25.
//

import UIKit

private var UIViewTapActionKey: UInt8 = 0

extension UIView {
    func addTapAction(_ action: @escaping () -> Void) {
        isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        addGestureRecognizer(gesture)
        
        objc_setAssociatedObject(self, &UIViewTapActionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleTapAction() {
        if let action = objc_getAssociatedObject(self, &UIViewTapActionKey) as? () -> Void {
            action()
        }
    }
}
