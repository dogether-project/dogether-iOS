//
//  CreateGroupRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import Foundation

struct CreateGroupRequest: GroupInfo, Encodable {
    let groupName: String
    let memberCount: Int
    let startAt: String
    let challengeDuration: Int
    let dailyTodoLimit: Int
    
    init(groupName: String, memberCount: Int, startAt: GroupStartAts, challengeDuration: GroupChallengeDurations, dailyTodoLimit: Int) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.startAt = startAt.rawValue
        self.challengeDuration = challengeDuration.rawValue
        self.dailyTodoLimit = dailyTodoLimit
    }
}
