//
//  ModalityManager.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import Foundation
import UIKit

final class ModalityManager {
    static let shared = ModalityManager()
    
    private init() { }
    
    var window: UIWindow?

    func show(reviews: [ReviewModel]? = nil) {
        guard window == nil else { return }
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let newWindow = UIWindow(windowScene: windowScene!)
        newWindow.frame = UIScreen.main.bounds
        newWindow.windowLevel = .alert + 1
        let modalityViewController = ModalityViewController()
        modalityViewController.viewModel.setReviews(reviews)
        newWindow.rootViewController = modalityViewController
        newWindow.isHidden = false
        self.window = newWindow
    }
    
    func dismiss() {
        window?.isHidden = true
        window = nil
    }
}
