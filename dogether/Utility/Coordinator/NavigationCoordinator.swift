//
//  NavigationCoordinator.swift
//  dogether
//
//  Created by seungyooooong on 3/21/25.
//

import UIKit

// MARK: AnyObject를 채택해 '클래스 전용' 프로토콜로 만들어 줌
protocol CoordinatorDelegate: AnyObject {
    var coordinator: NavigationCoordinator? { get set }
}

final class NavigationCoordinator: NSObject {
    private let navigationController: UINavigationController
    private var modalityWindow: UIWindow? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: view
extension NavigationCoordinator {
    // ???: 데이터를 더 안전하게 (coordinator를 통해) 전달하는 방식을 찾아보자

    func setNavigationController(_ viewController: BaseViewController, animated: Bool = true) {
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func pushViewController(_ viewController: BaseViewController, animated: Bool = true) {
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}

// MARK: popup
extension NavigationCoordinator {
    func showPopup(
        _ viewController: BaseViewController,
        type: PopupTypes,
        alertType: AlertTypes? = nil,
        todoInfo: TodoInfo? = nil,
        animated: Bool = true,
        completion: ((Any) -> Void)? = nil
    ) {
        let popupViewController = PopupViewController()
        
        popupViewController.coordinator = self
        popupViewController.completion = completion
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        
        popupViewController.viewModel.popupType = type
        popupViewController.viewModel.alertType = alertType
        popupViewController.viewModel.todoInfo = todoInfo
        
        viewController.present(popupViewController, animated: animated)
    }
    
    func hidePopup(animated: Bool = true) {
        if let modalityWindow {
            modalityWindow.rootViewController?.dismiss(animated: animated)
        } else {
            navigationController.viewControllers.last?.dismiss(animated: animated)
        }
    }
}

// MARK: modality
extension NavigationCoordinator {
    func showModal(reviews: [ReviewModel]? = nil) {
        if let modalityWindow {
            if let viewController = modalityWindow.rootViewController as? ModalityViewController {
                viewController.viewModel.setReviews(reviews)
            }
        } else {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = UIWindow(windowScene: windowScene!)
            let modalityViewController = ModalityViewController()
            
            modalityViewController.coordinator = self
            modalityViewController.viewModel.setReviews(reviews)
            window.frame = UIScreen.main.bounds
            window.rootViewController = modalityViewController
            window.windowLevel = .alert + 1
            window.makeKeyAndVisible()
            
            modalityWindow = window
        }
    }
    
    func hideModal() {
        modalityWindow?.isHidden = true
        modalityWindow = nil
    }
}

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}
