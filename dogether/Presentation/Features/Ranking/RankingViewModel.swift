//
//  RankingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import UIKit

final class RankingViewModel {
    private let groupUseCase: GroupUseCase
    
    private(set) var groupId: Int?   // FIXME: 메인 뷰에서 넘어올 때 지정해주도록 수정
    private(set) var rankings: [RankingModel] = []
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension RankingViewModel {
    func loadRankingView() async throws {
        try await getRankings()
    }
}

extension RankingViewModel {
    func getRankings() async throws {
        guard let groupId else { return }
        rankings = try await groupUseCase.getRankings(groupId: groupId)
    }
}
