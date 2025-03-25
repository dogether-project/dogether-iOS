//
//  GroupCreateRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class GroupCreateRepositoryTest: GroupCreateProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        return CreateGroupResponse(joinCode: "000000")
    }
}
