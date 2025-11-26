//
//  StatsGroupInfoViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/26/25.
//

struct StatsGroupInfoViewDatas: BaseEntity {
    let groupName: String
    let currentMemberCount: Int
    let maximumMemberCount: Int
    let joinCode: String
    let endDate: String
    
    init(
        groupName: String = "",
        currentMemberCount: Int = 0,
        maximumMemberCount: Int = 0,
        joinCode: String = "",
        endDate: String = ""
    ) {
        self.groupName = groupName
        self.currentMemberCount = currentMemberCount
        self.maximumMemberCount = maximumMemberCount
        self.joinCode = joinCode
        self.endDate = endDate
    }
}
