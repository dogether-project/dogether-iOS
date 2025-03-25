//
//  GroupCreateRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupCreateRepository: GroupCreateProtocol {
    private let groupsDataSource: GroupsDataSource
    
    init(groupsDataSource: GroupsDataSource = .shared) {
        self.groupsDataSource = groupsDataSource
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await groupsDataSource.createGroup(createGroupRequest: createGroupRequest)
    }
}
