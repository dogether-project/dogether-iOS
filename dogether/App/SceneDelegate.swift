//
//  SceneDelegate.swift
//  dogether
//
//  Created by seungyooooong on 1/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: NavigationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator = NavigationCoordinator(navigationController: navigationController)
        NetworkManager.shared.coordinator = coordinator
        PushNoticeManager.shared.delegate = coordinator
        
        Task { @MainActor in
            if let userActivity = connectionOptions.userActivities.first {
                DeepLinkManager.shared.resolveUrl(userActivity: userActivity)
            }
            
            coordinator?.setNavigationController(SplashViewController())
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        Task { @MainActor in
            DeepLinkManager.shared.resolveUrl(userActivity: userActivity)
            coordinator?.handleDeepLinkIfNeeded()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        coordinator?.updateLastAccessDate()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}
