//
//  MemberCertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import Foundation

final class MemberCertificationViewModel {
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    
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
        (currentIndex, todos) = try await challengeGroupsUseCase.getMemberTodos(groupId: 0, memberId: 0)  // FIXME: 추후 수정
        
    }
}
