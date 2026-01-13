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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        coordinator = NavigationCoordinator(navigationController: navigationController)
        coordinator?.setNavigationController(SplashViewController())
        
        NetworkManager.shared.coordinator = coordinator
        PushNoticeManager.shared.delegate = coordinator
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        Task { @MainActor in
            try await DeepLinkManager.shared.resolveUrl(userActivity: connectionOptions.userActivities.first)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        Task { @MainActor in
            try await DeepLinkManager.shared.resolveUrl(userActivity: userActivity)

            // ???: 초대 코드를 입력하는 화면에서 딥링크를 타고 들어왔을 때도 해당 로직을 타며 새 창이 뜨는 문제를 발견했습니다.
            /// 그냥 무조건 스플래시뷰로 이동시켜서 모든 상황에서 동일한 로직을 태우도록 만들면 어떨까요?
            /// 아니면 모든 상황에서 스플레시 뷰로 이동하지 않고, 스플레시 뷰와 동일한 로직을 태우도록 설계하는 것도 좋을 것 같습니다
            
//            if let code = DeepLinkManager.shared.consumeInviteCode() {
//                let groupJoinViewController = GroupJoinViewController()
//                let groupJoinViewDatas = GroupJoinViewDatas(code: code)
//                coordinator?.pushViewController(groupJoinViewController, datas: groupJoinViewDatas)
//            }
            coordinator?.setNavigationController(SplashViewController())
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        coordinator?.updateLastAccessDate()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

