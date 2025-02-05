//
//  LoginViewController.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    
    private let appleSignInDelegate = AppleSignInDelegate()
    private let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    private let logoutButton = UIButton()
    private let withdrawButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [signInButton, logoutButton, withdrawButton].forEach { view.addSubview($0) }
        
        signInButton.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.height.equalTo(40)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(signInButton.snp.bottom)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(logoutButton.snp.bottom)
        }
        
        logoutButton.setTitle("로그아웃", for: .normal)
        withdrawButton.setTitle("탈퇴하기", for: .normal)
        
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
    }
    
    @objc private func signInButtonClicked() {
        
        // Apple로 로그인을 시작할 메서드(버튼을 눌렀을때 호출할 메서드)
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 유저로부터 알 수 있는 정보들
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        // 로그인 정보 관련 대리자 설정
        // 인증창을 보여주기 위해 대리자 설정
        controller.delegate = appleSignInDelegate
        // 요청
        controller.performRequests()
    }
    
    @objc private func withdrawButtonClicked() {
        
        let request = ASAuthorizationAppleIDProvider()
        let userIdentifier = UserDefaultsManager.shared.userID
    }
}

// MARK: - 로그인 인증 화면 요청
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    
    // 인증창을 보여주기 위한 메서드(인증창을 보여줄 화면을 설정)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
