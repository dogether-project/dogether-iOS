//
//  GroupCreateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

struct GroupCreateViewDatas: BaseEntity {
    let groupNameMaxLength: Int = 10
    let memberMinimum: Int = 2
    let memberMaximum: Int = 20
    let memberUnit: String = "명"
    var step: CreateGroupSteps
    var memberCount: Int
    
    init(
        step: CreateGroupSteps = .one,
        member: Int = 10,
    ) {
        self.step = step
        self.memberCount = member
    }
}
