//
//  AppleSignInDelegate.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import Foundation
import AuthenticationServices

final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    
    private var continuation: CheckedContinuation<(identityToken: String, fullUserName: String), Error>?
    
    // 애플 로그인 결과 비동기 반환
    var signInResult: (identityToken: String, fullUserName: String)? {
        get async throws {
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
            }
        }
    }
    
    // MARK: - 로그인 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCrendential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCrendential.user
            let fullName = appleIDCrendential.fullName
            
            guard let identityTokenData = appleIDCrendential.identityToken,
                  let identityTokenString = String(data: identityTokenData, encoding: .utf8),
                  let authrizationCode = appleIDCrendential.authorizationCode else {
                continuation?.resume(throwing: NetworkError.unknown)
                return
            }
                        
            let firstName = fullName?.givenName ?? "이름없음"
            let lastName = fullName?.familyName ?? "이름없음"
            let fullUserName = firstName + lastName
            
            UserDefaultsManager.shared.userFullName = fullUserName
            
            // TODO: - OSLog로 변경하기
            print("============= 🚀 Login Log 🚀 =============")
            print("✅ 로그인 성공")
            print("사용자 ID: \(userIdentifier)")
            print("사용자 이름: \(fullUserName)")
            print("사용자 Token: \(identityTokenString)")
            print("사용자 authorizationCode: \(authrizationCode)")
            print("===========================================")
            
            // 비동기 결과 반환
            continuation?.resume(returning: (identityTokenString, fullUserName))
            
        // MARK: - 암호 기반 인증에 성공한 경우, 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
        case let passwordCredential as ASPasswordCredential:
            
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            print("============= 🚀 Login Log 🚀 =============")
            print("✅ 암호 기반 인증 성공")
            print("사용자 이름: \(userName)")
            print("사용자 비밀번호: \(password)")
            print("===========================================")
            
        default:
            continuation?.resume(throwing: NetworkError.unknown)
        }
    }
}
