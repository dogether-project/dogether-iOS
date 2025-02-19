//
//  CreateGroupRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import Foundation

struct CreateGroupRequest: Encodable {
    let name: String
    let maximumMemberCount: Int
    let startAt: String
    let durationOption: Int
    let maximumTodoCount: Int
    
    init(name: String, maximumMemberCount: Int, startAt: GroupStartAts, durationOption: GroupChallengeDurations, maximumTodoCount: Int) {
        self.name = name
        self.maximumMemberCount = maximumMemberCount
        self.startAt = startAt.rawValue
        self.durationOption = durationOption.rawValue
        self.maximumTodoCount = maximumTodoCount
    }
}
