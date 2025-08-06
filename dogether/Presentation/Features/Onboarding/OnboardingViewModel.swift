//
//  OnboardingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import RxRelay

final class OnboardingViewModel {
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    
    let onboardingStep = BehaviorRelay<Int>(value: 3)
    private(set) var isParticipating = BehaviorRelay<Bool>(value: true)
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }

    func signInWithApple() async throws {
        authUseCase.appleLogin()
        try await authUseCase.login(domain: .apple)
    }
    
    func checkParticipating() async throws {
        isParticipating.accept(try await groupUseCase.getIsParticipating())
    }
}
