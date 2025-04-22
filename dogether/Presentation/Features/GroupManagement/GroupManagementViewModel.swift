//
//  GroupManagementViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

final class GroupManagementViewModel {
    var groups: [GroupInfo] = [
        GroupInfo(name: "test1"),
        GroupInfo(name: "test2"),
        GroupInfo(name: "test3"),
    ]
    
    private let authUseCase: AuthUseCase
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        self.authUseCase = AuthUseCase(repository: authRepository)
    }
}

extension GroupManagementViewModel {
    func leaveGroup() async throws {
        // FIXME: UI 수정 후 내용 반영
        try await NetworkManager.shared.request(GroupsRouter.leaveGroup)
    }
}

