//
//  UIApplicationExt.swift
//  dogether
//
//  Created by seungyooooong on 8/29/25.
//

import UIKit

extension UIApplication {
    static var bottomSafeAreaOffset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first  else { return 0.0 }
        return window.safeAreaInsets.bottom
    }
}
