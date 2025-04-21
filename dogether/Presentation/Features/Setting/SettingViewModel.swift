//
//  MyPageViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class SettingViewModel {
    private let authUseCase: AuthUseCase
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        self.authUseCase = AuthUseCase(repository: authRepository)
    }
}

extension SettingViewModel {
    func leaveGroup() async throws {
        // FIXME: UI 수정 후 내용 반영
        try await NetworkManager.shared.request(GroupsRouter.leaveGroup)
    }
    
    func logout() {
        UserDefaultsManager.shared.accessToken = nil
        UserDefaultsManager.shared.userFullName = nil
    }
    
    func withdraw() async throws {
        authUseCase.appleLogin()
        guard let userInfo = try await authUseCase.userInfo else { return }
        
        let withdrawRequst = WithdrawRequest(authorizationCode: userInfo.authorizationCode)
        try await NetworkManager.shared.request(AuthRouter.withdraw(withdrawRequest: withdrawRequst))
    }
}

