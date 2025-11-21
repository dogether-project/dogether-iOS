//
//  StatsPageViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/18/25.
//

import Foundation

struct StatsPageViewDatas: BaseEntity {
    var status: StatsViewStatus
    var groupInfo: StatsGroupInfoViewDatas?
    var achievementBar: DailyAchievementBarViewDatas?
    var myRank: MyRankViewDatas?
    var summary: StatsSummaryViewDatas?
    
    var groupSortOptions: [GroupSortOption]
    var selectedGroup: GroupSortOption?

    init(
        status: StatsViewStatus = .empty,
        groupInfo: StatsGroupInfoViewDatas? = nil,
        achievementBar: DailyAchievementBarViewDatas? = nil,
        myRank: MyRankViewDatas? = nil,
        summary: StatsSummaryViewDatas? = nil,
        groupSortOptions: [GroupSortOption] = [],
        selectedGroup: GroupSortOption? = nil
    ) {
        self.status = status
        self.groupInfo = groupInfo
        self.achievementBar = achievementBar
        self.myRank = myRank
        self.summary = summary
        self.groupSortOptions = groupSortOptions
        self.selectedGroup = selectedGroup
    }
}

struct StatsGroupInfoViewDatas: BaseEntity {
    let groupName: String
    let currentMemberCount: Int
    let maximumMemberCount: Int
    let joinCode: String
    let endDate: String
}

struct DailyAchievementBarViewDatas: BaseEntity {
    let achievements: [DailyAchievementViewData]
}

struct MyRankViewDatas: BaseEntity {
    let totalMembers: Int
    let myRank: Int
}

struct StatsSummaryViewDatas: BaseEntity {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}

struct DailyAchievementViewData: Hashable {
    let day: Int
    let createdCount: Int
    let certificationRate: Int
}

struct GroupSortOption: BottomSheetItemRepresentable, Hashable {
    let groupId: Int
    let groupName: String
    
    var displayName: String {
        return groupName
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}
