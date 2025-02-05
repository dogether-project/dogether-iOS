//
//  AppleSignInDelegate.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import Foundation
import AuthenticationServices

final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    
    // MARK: - 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCrendential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCrendential.user
            let fullName = appleIDCrendential.fullName
            let email = appleIDCrendential.email
            guard let identityToken = appleIDCrendential.identityToken else { return }
            guard let authrizationCode = appleIDCrendential.authorizationCode else { return }
            
            UserDefaultsManager.shared.userID = userIdentifier
            
            if let firstName = fullName?.givenName,
               let lastName = fullName?.familyName {
                let fullUserName = "\(firstName) \(lastName)"
                UserDefaultsManager.shared.userFullName = fullUserName
            }
            
            if let email = email {
                UserDefaultsManager.shared.email = email
            }
            
            let savedName = UserDefaultsManager.shared.userFullName
            let savedEmail = UserDefaultsManager.shared.email
            
            print("============= 🚀 Login Log 🚀 =============")
            print("✅ 로그인 성공")
            print("사용자 ID: \(userIdentifier)")
            print("사용자 이름: \(fullName?.givenName ?? "")")
            print("사용자 이메일: \(email ?? "")")
            print("사용자 Token: \(identityToken)")
            print("사용자 authorizationCode: \(authrizationCode)")
            print("===========================================")
            
            // TODO: - 로그인 성공 후 수행할 작업
            
        // MARK: - 암호 기반 인증에 성공한 경우(iCloud), 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            print("============= 🚀 Login Log 🚀 =============")
            print("✅ 암호 기반 인증 성공")
            print("사용자 이름: \(userName)")
            print("사용자 비밀번호: \(password)")
            print("===========================================")
            
            // TODO: - 로그인 성공 후 수행할 작업

        default:
            break
        }
    }
    
    // MARK: - 로그인 실패(유저의 취소도 포함)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("============= 🚀 Login Log 🚀 =============")
        print("🚨 로그인 실패: \(error.localizedDescription)")
        print("===========================================")
    }
}
