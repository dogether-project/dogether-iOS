//
//  NavigationCoordinator.swift
//  dogether
//
//  Created by seungyooooong on 3/21/25.
//

import UIKit
import Combine

// MARK: AnyObject를 채택해 '클래스 전용' 프로토콜로 만들어 줌
protocol CoordinatorDelegate: AnyObject {
    var coordinator: NavigationCoordinator? { get set }
}

final class NavigationCoordinator: NSObject {
    private let navigationController: UINavigationController
    private let loadingViewTag = 9999
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        bindLoadingEvents()
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
        todoInfo: TodoInfo? = nil,
        rejectPopupCompletion: ((String) -> Void)? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let popupViewController = PopupViewController()
        popupViewController.coordinator = self
        popupViewController.popupType = type
        popupViewController.todoInfo = todoInfo
        popupViewController.rejectPopupCompletion = rejectPopupCompletion
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        viewController.present(popupViewController, animated: animated, completion: completion)
    }
    
    func hidePopup(animated: Bool = true) {
        navigationController.viewControllers.last?.dismiss(animated: animated)
    }
}

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}

// MARK: - loadingView
extension NavigationCoordinator {
    private func bindLoadingEvents() {
        LoadingManager.shared.loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoadingView() : self?.hideLoadingView()
            }
            .store(in: &cancellables)
    }
    
    private func showLoadingView() {
        guard navigationController.view.viewWithTag(loadingViewTag) == nil else { return }

        let loadingView = LoadingView(frame: navigationController.view.bounds)
        loadingView.tag = loadingViewTag
        navigationController.view.addSubview(loadingView)
    }

    private func hideLoadingView() {
        navigationController.view.viewWithTag(loadingViewTag)?.removeFromSuperview()
    }
}
