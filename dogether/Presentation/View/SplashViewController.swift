//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import Foundation
import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let logoView = UIView()
    
    private let logoImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        return imageView
    }()
    
    private let logoTypoImageView = {
        let imageView = UIImageView()
        imageView.image = .logoTypo
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 추후 viewModel로 이동
        Task { @MainActor in
            let response: GetIsJoiningResponse = try await NetworkManager.shared.request(GroupsRouter.getIsJoining)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if UserDefaultsManager.shared.accessToken == nil {
                    NavigationManager.shared.setNavigationController(OnboardingViewController())
                } else if response.isJoining {
                    NavigationManager.shared.setNavigationController(MainViewController())
                } else {
                    NavigationManager.shared.setNavigationController(StartViewController())
                }
            }
        }
    }
    
    override func configureView() { }
    
    override func configureHierarchy() {
        [logoView].forEach { view.addSubview($0) }
        [logoImageView, logoTypoImageView].forEach { logoView.addSubview($0) }
    }
    
    override func configureConstraints() {
        logoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(127)
            $0.height.equalTo(136)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(82)
        }
        
        logoTypoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(127)
            $0.height.equalTo(30)
        }
    }
}
