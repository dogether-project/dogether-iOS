//
//  LoginViewController.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginViewController: BaseViewController {
    
    private let viewModel = LoginViewModel()
    
    private let dogetherLabel = {
        let label = UILabel()
        label.text = "함께하면 두개 더,\n지금부터 Do Gether"
        label.font = Fonts.head1B
        label.textColor = .grey900
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let logo = {
        let logo = UIImageView()
        logo.image = .logo
        return logo
    }()
    
    private lazy var signInButton =  {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [dogetherLabel, logo, signInButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        
        dogetherLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(162)
        }
        
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogetherLabel.snp.bottom).offset(54)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(100)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() { }
    
    @objc private func signInButtonClicked() {
        Task {
            let response = try await viewModel.singInWithApple()
            print("✅ 로그인 성공: \(response.name), 토큰: \(response.accessToken)")
            
            UserDefaultsManager.shared.userFullName = response.name
            UserDefaultsManager.shared.accessToken = response.accessToken
            
            // 로그인 성공 후 이동하는 로직
            self.navigationController?.setViewControllers([LoginSuccessViewController()], animated: true)
        }
    }
}

// MARK: - 로그인 인증 화면 요청
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    
    // 인증창을 보여주기 위한 메서드(인증창을 보여줄 화면을 설정)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
