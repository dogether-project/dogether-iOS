//
//  StatsRepository.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsRepository: StatsProtocol {
    private let dataSoruce: StatsDataSource
    
    init(dataSoruce: StatsDataSource = .shared) {
        self.dataSoruce = dataSoruce
    }
    
    func fetchGroupStats(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        let response = try await dataSoruce.fetchGroupStats(groupId: groupId)
        
        let achievementViewDatas = AchievementViewDatas(
            achievements: response.certificationPeriods.map {
                AchievementEntity(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )
        
        let rankViewDatas = StatsRankViewDatas(
            totalMembers: response.ranking.totalMemberCount,
            myRank: response.ranking.myRank
        )
        
        let summaryViewDatas = StatsSummaryViewDatas(
            certificatedCount: response.stats.certificatedCount,
            approvedCount: response.stats.approvedCount,
            rejectedCount: response.stats.rejectedCount
        )
        
        return (achievementViewDatas, rankViewDatas, summaryViewDatas)
    }
}
