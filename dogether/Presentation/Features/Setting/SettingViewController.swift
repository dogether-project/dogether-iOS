//
//  SettingViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let viewModel = SettingViewModel()
    
    private let dogetherHeader = NavigationHeader(title: "설정")
    private let logoutButton = MyPageButton(icon: nil, title: "로그아웃")
    private let withdrawButton = MyPageButton(icon: nil, title: "회원탈퇴")
    private let appVersionView: UIView = {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "앱 버전"
        titleLabel.textColor = .grey100
        titleLabel.font = Fonts.body1R
        
        let versionLabel = UILabel()
        versionLabel.text = "1.0.0" // 앱버전 넣기
        versionLabel.textColor = .grey100
        versionLabel.font = Fonts.body1R
        
        container.addSubview(titleLabel)
        container.addSubview(versionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        versionLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return container
    }()

    
    private let settingStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        [logoutButton, withdrawButton, appVersionView].forEach { settingStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        dogetherHeader.delegate = self
        
        logoutButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showPopup(self, type: .alert, alertType: .logout) { _ in
                    self.viewModel.logout()
                    self.coordinator?.setNavigationController(OnboardingViewController())
                }
            }, for: .touchUpInside
        )
        
        withdrawButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showPopup(self, type: .alert, alertType: .withdraw) { _ in
                    Task {
                        try await self.viewModel.withdraw()
                        self.viewModel.logout()
                        await MainActor.run {
                            self.coordinator?.setNavigationController(OnboardingViewController())
                        }
                    }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [dogetherHeader, settingStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
