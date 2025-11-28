//
//  StatsRepositoryTest.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsRepositoryTest: StatsProtocol {
    func fetchGroupStats(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        guard let url = Bundle.main.url(forResource: "StatsMock", withExtension: "json") else {
           throw URLError(.fileDoesNotExist)
       }
       let data = try Data(contentsOf: url)
       let response = try JSONDecoder().decode(GroupStatsResponse.self, from: data)
        
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
