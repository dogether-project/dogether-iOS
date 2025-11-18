//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation
import RxRelay

final class StatsViewModel {
    private let statsUseCase: StatsUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var statsViewDatas = BehaviorRelay<StatsViewDatas>(value: StatsViewDatas())
    
    init() {
        let statsRepository = DIManager.shared.getStatsRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        self.statsUseCase = StatsUseCase(repository: statsRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension StatsViewModel {
    func loadStatsView() async throws {
        try await fetchMyGroups()
    }
}

extension StatsViewModel {
    private func fetchMyGroups() async throws {
        let (groupIndex, challengeGroups) = try await groupUseCase.getChallengeGroupInfos()
        
        statsViewDatas.update {
            $0.groupSortOptions = challengeGroups.map {
                GroupSortOption(groupId: $0.id, groupName: $0.name)
            }
        }
        
        guard !challengeGroups.isEmpty else {
            statsViewDatas.update { $0.status = .empty }
            return
        }
        
        if let index = groupIndex {
            let current = challengeGroups[index]
            let selected = GroupSortOption(groupId: current.id, groupName: current.name)
            
            statsViewDatas.update { $0.selectedGroup = selected }
            
            try await fetchStatsForSelectedGroup(selected)
        }
    }
}

extension StatsViewModel {
    func fetchStatsForSelectedGroup(_ option: GroupSortOption) async throws {
        let response = try await statsUseCase.fetchGroupStats(groupId: option.groupId)
        
        statsViewDatas.update {
            $0.status = .hasData
            
            $0.groupName = response.groupInfo.name
            $0.endDate = response.groupInfo.endAt
            $0.maxMemberCount = response.groupInfo.maximumMemberCount
            $0.currentMemberCount = response.groupInfo.currentMemberCount
            $0.joinCode = response.groupInfo.joinCode
            
            $0.myRank = response.ranking.myRank
            $0.totalMembers = response.ranking.totalMemberCount
            
            $0.certificatedCount = response.stats.certificatedCount
            $0.approvedCount = response.stats.approvedCount
            $0.rejectedCount = response.stats.rejectedCount
            
            $0.dailyAchievements = response.certificationPeriods.map {
                DailyAchievementViewData(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
            
            $0.selectedGroup = option
        }
    }
}
