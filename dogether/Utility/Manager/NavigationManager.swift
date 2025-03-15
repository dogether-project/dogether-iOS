//
//  NavigationManager.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

final class NavigationManager: NSObject {
    static let shared = NavigationManager()

    private override init() {}
    
    private var navigationController: UINavigationController? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.rootViewController as? UINavigationController }
            .first
    }

    func setNavigationController(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func pushViewController<T: UIViewController>(
        _ viewController: T,
        with data: ((T) -> Void)? = nil,
        animated: Bool = true
    ) {
        guard let navigationController = navigationController else { return }
        data?(viewController) // 클로저를 이용해 데이터 설정
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: animated)
    }
}

extension NavigationManager: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
