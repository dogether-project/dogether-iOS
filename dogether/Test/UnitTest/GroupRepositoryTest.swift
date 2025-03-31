//
//  GroupRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class GroupRepositoryTest: GroupProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        return CreateGroupResponse(joinCode: "000000")
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        return JoinGroupResponse(name: "testGroup", maximumMemberCount: 10, startAt: "2025-01-01", endAt: "2025-01-04", durationOption: 3)
    }
}
