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

// TODO: 추후 Domain - Entity로 이동
enum GroupStartAts: String {
    case today = "TODAY"
    case tommorow = "TOMMOROW"
}

enum GroupChallengeDurations: Int {
    case threeDays = 3
    case oneWeek = 7
    case twoWeeks = 14
    case fourWeeks = 28
    
    var text: String {
        switch self {
        case .threeDays:
            return "3일"
        case .oneWeek:
            return "1주"
        case .twoWeeks:
            return "2주"
        case .fourWeeks:
            return "4주"
        }
    }
}
