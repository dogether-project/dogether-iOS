//
//  GroupManagementViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

enum GroupManagementViewStatus {
    case empty
    case hasData
}

final class GroupManagementViewModel {    
    private(set) var groups: [ChallengeGroup] = []
    
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    
    var viewStatus: GroupManagementViewStatus = .empty
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupManagementViewModel {
    func fetchMyGroup(completion: @escaping () -> Void) {
        Task {
            do {
                let response = try await groupUseCase.getMyGroup()
                self.groups = response.joiningChallengeGroups
                viewStatus = groups.isEmpty ? .empty : .hasData
                DispatchQueue.main.async {
                    completion()  // 데이터 갱신 후 테이블 뷰 리로드
                }
            } catch {
                self.viewStatus = .empty
            }
        }
    }
}

extension GroupManagementViewModel {
    func leaveGroup(groupId: Int) async throws {
        try await groupUseCase.leaveGroup(groupId: groupId)
    }
}

