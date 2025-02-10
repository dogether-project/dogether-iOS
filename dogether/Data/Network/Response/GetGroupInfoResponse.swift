//
//  GetGroupInfoResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetGroupInfoResponse: GroupInfo, Decodable {
    let groupName: String
    let memberCount: Int
    let dailyTodoLimit: Int
}
