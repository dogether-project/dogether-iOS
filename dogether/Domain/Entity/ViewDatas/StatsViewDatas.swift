//
//  StatsViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/18/25.
//

import Foundation

struct StatsViewDatas: BaseEntity {
    var status: StatsViewStatus
    var groupName: String
    var endDate: String
    var maxMemberCount: Int
    var currentMemberCount: Int
    var joinCode: String
    
    var dailyAchievements: [DailyAchievementViewData]
    
    var myRank: Int
    var totalMembers: Int
    
    var certificatedCount: Int
    var approvedCount: Int
    var rejectedCount: Int
    
    var groupSortOptions: [GroupSortOption]
    var selectedGroup: GroupSortOption?
    
    init(
        status: StatsViewStatus = .empty,
        groupName: String = "",
        endDate: String = "",
        maxMemberCount: Int = 0,
        currentMemberCount: Int = 0,
        joinCode: String = "",
        
        dailyAchievements: [DailyAchievementViewData] = [],
        
        myRank: Int = 0,
        totalMembers: Int = 0,
        
        certificatedCount: Int = 0,
        approvedCount: Int = 0,
        rejectedCount: Int = 0,
        
        groupSortOptions: [GroupSortOption] = [],
        selectedGroup: GroupSortOption? = nil
    ) {
        self.status = status
        
        self.groupName = groupName
        self.endDate = endDate
        self.maxMemberCount = maxMemberCount
        self.currentMemberCount = currentMemberCount
        self.joinCode = joinCode
        
        self.dailyAchievements = dailyAchievements
        
        self.myRank = myRank
        self.totalMembers = totalMembers
        
        self.certificatedCount = certificatedCount
        self.approvedCount = approvedCount
        self.rejectedCount = rejectedCount
        
        self.groupSortOptions = groupSortOptions
        self.selectedGroup = selectedGroup
    }
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
