//
//  OnboardingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class OnboardingViewModel {
    private let authUseCase: AuthUseCase
    private let appLaunchUseCase: AppLaunchUseCase
    
    let onboardingStep: Int = 3
    
    private(set) var destination: BaseViewController?
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let appLaunchRepository = DIManager.shared.getAppLaunchRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
    }

    func signInWithApple() async throws {
        authUseCase.appleLogin()
        guard let userInfo = try await authUseCase.userInfo else { return }
        
        let appleLoginRequest = AppleLoginRequest(name: userInfo.name, idToken: userInfo.idToken)
        try await authUseCase.appleLogin(appleLoginRequest: appleLoginRequest)
        
        destination = try await appLaunchUseCase.getDestination()
    }
}
