//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        pages = [splashPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
}

extension SplashViewController {
    private func onAppear() {
        Task {
            try await viewModel.launchApp()
            
            if try await viewModel.checkUpdate() {
                coordinator?.setNavigationController(UpdateViewController())
                return
            }
            
            if viewModel.checkLogin() {
                coordinator?.setNavigationController(OnboardingViewController())
                return
            }
            
            let rootVC: BaseViewController
            
            if try await viewModel.checkParticipating() {
                rootVC = StartViewController()
            } else {
                rootVC = MainViewController()
            }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                coordinator?.setNavigationController(rootVC)
            }
            
            if let code = DeepLinkManager.shared.consumeInviteCode() {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    coordinator?.pushViewController(
                        GroupJoinViewController(),
                        datas: GroupJoinDeepLinkViewDatas(inviteCode: code)
                    )
                }
            }
        }
    }
}
