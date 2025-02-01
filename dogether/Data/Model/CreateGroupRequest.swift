//
//  CreateGroupRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import Foundation

struct CreateGroupRequest: Encodable {
    let groupName: String = "성욱이와 친구들"
    let memberCount: Int = 7
    let startAt: String = "TODAY"   // TODO: 추후 enum 생성
    let challengeDuration: Int = 7  // TODO: 추후 enum 생성
    let dailyTodoLimit: Int = 5
}
