//
//  GroupCreateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

struct GroupCreateViewDatas: BaseEntity {
    var step: CreateGroupSteps
    var groupName: String
    var memberCount: Int
    
    init(
        step: CreateGroupSteps = .one,
        groupName: String = "",
        member: Int = 10,
    ) {
        self.step = step
        self.groupName = groupName
        self.memberCount = member
    }
}
