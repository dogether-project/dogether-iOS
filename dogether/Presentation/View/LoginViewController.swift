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
    
    private let appleSignInDelegate = AppleSignInDelegate()
    
    private let dogetherLabel = {
        let label = UILabel()
        label.text = "함께하면 두개 더,\n지금부터 Do Gether"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logo = {
        let logo = UIImageView()
        logo.image = .logo
        return logo
    }()
    
    private let signInButton =  {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(160)
        }
        
        logo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogetherLabel.snp.bottom).offset(56)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(40)
            $0.height.equalTo(40)
        }
    }
    
    override func configureView() { }
    
    @objc private func signInButtonClicked() {
        
        // Apple로 로그인을 시작할 메서드(버튼을 눌렀을때 호출할 메서드)
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 유저로부터 알 수 있는 정보들
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        // 인증창을 보여주기 위해 로그인 정보 관련 대리자 설정
        controller.delegate = appleSignInDelegate
        controller.performRequests()
    }
    
//    @objc private func withdrawButtonClicked() {
//        
//        let request = ASAuthorizationAppleIDProvider()
//        let userIdentifier = UserDefaultsManager.shared.userID
//    }
}

// MARK: - 로그인 인증 화면 요청
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    
    // 인증창을 보여주기 위한 메서드(인증창을 보여줄 화면을 설정)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
