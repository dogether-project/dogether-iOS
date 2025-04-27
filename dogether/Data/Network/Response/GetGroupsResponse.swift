//
//  GetGroupsResponse.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import Foundation

struct GetGroupsResponse: Decodable {
    let joinChallengeGroups: [JoinChallengeGroup]
}

struct JoinChallengeGroup: Decodable {
    let groupId: Int
    let groupName: String
    let currentMemberCount: Int
    let maximumMemberCount: Int
    let joinCode: String
    let endAt: String
    let currentDay: Int
}
