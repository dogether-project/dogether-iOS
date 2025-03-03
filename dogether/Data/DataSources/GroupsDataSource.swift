//
//  GroupsDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class GroupsDataSource {
    static let shared = GroupsDataSource()
    
    private init() { }
    
    func getIsJoining() async throws -> Bool {
        let response: GetIsJoiningResponse = try await NetworkManager.shared.request(GroupsRouter.getIsJoining)
        return response.isJoining
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> String {
        let response: CreateGroupResponse = try await NetworkManager.shared.request(
            GroupsRouter.createGroup(createGroupRequest: createGroupRequest)
        )
        return response.joinCode
    }
}
