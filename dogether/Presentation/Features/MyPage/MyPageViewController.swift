//
//  MyPageViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

import UIKit
import SnapKit

final class MyPageViewController: BaseViewController {
    private let viewModel = MyPageViewModel()
    
    private let dogetherHeader = NavigationHeader(title: "마이페이지")
    
    // FIXME: API 수정 후 내용 반영
    private let profileImageView = UIImageView(image: .profile2)
    
    private let nameLabel = {
        let label = UILabel()
        label.text = "\(UserDefaultsManager.shared.userFullName ?? "")"
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let leaveGroupButton = MyPageButton(icon: .leaveGroup, title: "그룹탈퇴")
    private let logoutButton = MyPageButton(icon: .logout, title: "로그아웃")
    private let withdrawButton = MyPageButton(icon: .withdraw, title: "회원탈퇴")
    
    private let mypageButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        dogetherHeader.delegate = self
        
        leaveGroupButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showPopup(self, type: .alert, alertType: .leaveGroup) { _ in
                    Task {
                        try await self.viewModel.leaveGroup()
                        await MainActor.run {
                            self.coordinator?.setNavigationController(StartViewController())
                        }
                    }
                }
            }, for: .touchUpInside
        )
        
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
        
        [leaveGroupButton, logoutButton, withdrawButton].forEach { mypageButtonStackView.addArrangedSubview($0) }
    }
    
    override func configureHierarchy() {
        [dogetherHeader, profileImageView, nameLabel, mypageButtonStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        mypageButtonStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(56)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

