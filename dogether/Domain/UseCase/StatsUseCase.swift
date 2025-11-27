//
//  StatsUseCase.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsUseCase {
    private let repository: StatsProtocol
    
    init(repository: StatsProtocol) {
        self.repository = repository
    }
    
    func fetchGroupStats(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        try await repository.fetchGroupStats(groupId: groupId)
    }
}
