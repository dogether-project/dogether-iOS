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
    private(set) var achievementViewDatas = BehaviorRelay<AchievementViewDatas>(value:AchievementViewDatas())
    private(set) var myRankViewDatas = BehaviorRelay<StatsRankViewDatas>(value: StatsRankViewDatas())
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
        let (achievement, myRank, summary) = try await statsUseCase.fetchGroupStats(groupId: currentGroup.id)
        
        statsPageViewDatas.update {
            $0.status = .hasData
        }
        
        achievementViewDatas.accept(achievement)
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
