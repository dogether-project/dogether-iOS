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
    
    private(set) var statsPageViewDatas = BehaviorRelay<StatsPageViewDatas>(value: StatsPageViewDatas())
    private(set) var groupInfoViewDatas = BehaviorRelay<StatsGroupInfoViewDatas>(value: StatsGroupInfoViewDatas())
    private(set) var achievementBarViewDatas = BehaviorRelay<DailyAchievementBarViewDatas>(value:DailyAchievementBarViewDatas())
    private(set) var myRankViewDatas = BehaviorRelay<MyRankViewDatas>(value: MyRankViewDatas())
    private(set) var summaryViewDatas = BehaviorRelay<StatsSummaryViewDatas>(value: StatsSummaryViewDatas())
    private(set) var groupSortViewDatas = BehaviorRelay<GroupSortViewDatas>(value: GroupSortViewDatas())
    
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
        
        let options = challengeGroups.map {
            GroupSortOption(groupId: $0.id, groupName: $0.name)
        }
        
        groupSortViewDatas.update { viewDatas in
            viewDatas.options = options
        }
        
        guard !challengeGroups.isEmpty else {
            statsPageViewDatas.update { $0.status = .empty }
            return
        }
        
        if let index = groupIndex {
            let current = challengeGroups[index]
            let selected = GroupSortOption(
                groupId: current.id,
                groupName: current.name
            )
            
            groupSortViewDatas.update {
                $0.selected = selected
            }
            
            try await fetchStatsForSelectedGroup(selected)
        }
    }
}

extension StatsViewModel {
    func fetchStatsForSelectedGroup(_ option: GroupSortOption) async throws {
        let response = try await statsUseCase.fetchGroupStats(groupId: option.groupId)
        
        let groupInfo = StatsGroupInfoViewDatas(
            groupName: response.groupInfo.name,
            currentMemberCount: response.groupInfo.currentMemberCount,
            maximumMemberCount: response.groupInfo.maximumMemberCount,
            joinCode: response.groupInfo.joinCode,
            endDate: response.groupInfo.endAt
        )
        
        let achievementBar = DailyAchievementBarViewDatas(
            achievements: response.certificationPeriods.map {
                DailyAchievementViewData(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )
        
        let myRank = MyRankViewDatas(
            totalMembers: response.ranking.totalMemberCount,
            myRank: response.ranking.myRank
        )
        
        let summary = StatsSummaryViewDatas(
            certificatedCount: response.stats.certificatedCount,
            approvedCount: response.stats.approvedCount,
            rejectedCount: response.stats.rejectedCount
        )
        
        statsPageViewDatas.update {
            $0.status = .hasData
        }
        
        groupInfoViewDatas.accept(groupInfo)
        achievementBarViewDatas.accept(achievementBar)
        myRankViewDatas.accept(myRank)
        summaryViewDatas.accept(summary)
        
        groupSortViewDatas.update {
            $0.selected = option
        }
    }
}
