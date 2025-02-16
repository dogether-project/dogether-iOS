//
//  PopupManager.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import Foundation
import UIKit

final class PopupManager {
    static let shared = PopupManager()

    private init() {}

    func showPopup(type: PopupTypes, animated: Bool = true, completion: (() -> Void)? = nil, todoInfo: TodoInfo? = nil) {
        guard let currentViewController = getCurrentViewController() else { return }

        let popupViewController = PopupViewController()
        popupViewController.popupType = type
        popupViewController.todoInfo = todoInfo
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        currentViewController.present(popupViewController, animated: animated, completion: completion)
    }
    
    func hidePopup(animated: Bool = true) {
        guard let currentViewController = getCurrentViewController() else { return }
        currentViewController.dismiss(animated: animated)
    }

    private func getCurrentViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return nil
        }
        
        var currentViewController = rootViewController
        while let presentedViewController = currentViewController.presentedViewController {
            currentViewController = presentedViewController
        }
        
        return currentViewController
    }
}
