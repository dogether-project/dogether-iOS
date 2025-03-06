//
//  GroupCreateRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupCreateRepository: GroupCreateInterface {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await GroupsDataSource.shared.createGroup(createGroupRequest: createGroupRequest)
    }
}
