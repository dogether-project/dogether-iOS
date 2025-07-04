//
//  MemberCertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import Foundation

final class MemberCertificationViewModel {
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    
    var groupId: Int?
    var memberInfo: RankingModel?
    
    private(set) var todos: [MemberCertificationInfo] = []
    private(set) var currentIndex: Int = 0
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
    }
}

extension MemberCertificationViewModel {
    func setCurrentIndex(index: Int) {
        todos[currentIndex].thumbnailStatus = .done
        
        self.currentIndex = index
    }
}

extension MemberCertificationViewModel {
    func loadMemberCertificationView() async throws {
        guard let groupId, let memberInfo else { return }
        (currentIndex, todos) = try await challengeGroupsUseCase.getMemberTodos(groupId: groupId, memberId: memberInfo.memberId)
    }
    
    func readTodo() {
        Task { [weak self] in
            guard let self else { return }
            try await challengeGroupsUseCase.readTodo(todoId: todos[currentIndex].id)
        }
    }
}
