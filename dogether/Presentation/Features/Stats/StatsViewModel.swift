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
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var statsPageViewDatas = BehaviorRelay<StatsPageViewDatas>(value: StatsPageViewDatas())
    private(set) var groupViewDatas = BehaviorRelay<GroupViewDatas>(value: GroupViewDatas())
    private(set) var achievementBarViewDatas = BehaviorRelay<DailyAchievementBarViewDatas>(value:DailyAchievementBarViewDatas())
    private(set) var myRankViewDatas = BehaviorRelay<MyRankViewDatas>(value: MyRankViewDatas())
    private(set) var summaryViewDatas = BehaviorRelay<StatsSummaryViewDatas>(value: StatsSummaryViewDatas())
    
    // MARK: - Computed
    var currentGroup: GroupEntity { groupViewDatas.value.groups[groupViewDatas.value.index] }
    
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
        let (groupIndex, groups) = try await groupUseCase.getGroups()
        
        guard let groupIndex else { return }
        groupViewDatas.accept(GroupViewDatas(index: groupIndex, groups: groups))
        
        guard !groups.isEmpty else {
            statsPageViewDatas.update { $0.status = .empty }
            return
        }
        
        try await fetchStatsForSelectedGroup()
    }
}

extension StatsViewModel {
    func fetchStatsForSelectedGroup() async throws {
        let response = try await statsUseCase.fetchGroupStats(groupId: currentGroup.id)
        
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
        
        achievementBarViewDatas.accept(achievementBar)
        myRankViewDatas.accept(myRank)
        summaryViewDatas.accept(summary)
    }
}

extension StatsViewModel {
    func saveLastSelectedGroupIndex(index: Int) {
        Task {
            try await groupUseCase.saveLastSelectedGroup(groupId: groupViewDatas.value.groups[index].id)
        }
    }
}
