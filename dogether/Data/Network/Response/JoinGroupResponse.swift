//
//  JoinGroupResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import Foundation

struct JoinGroupResponse: Decodable {
    let groupName: String
    let maximumMemberCount: Int
    let startAt: String
    let endAt: String
}

