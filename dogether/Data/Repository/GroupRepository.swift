//
//  GroupRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupRepository: GroupProtocol {
    private let groupsDataSource: GroupsDataSource
    
    init(groupsDataSource: GroupsDataSource = .shared) {
        self.groupsDataSource = groupsDataSource
    }
    
    func getIsJoining() async throws -> GetIsJoiningResponse {
        try await groupsDataSource.getIsJoining()
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await groupsDataSource.createGroup(createGroupRequest: createGroupRequest)
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        try await groupsDataSource.joinGroup(joinGroupRequest: joinGroupRequest)
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        try await groupsDataSource.getGroupInfo()
    }
    
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        try await groupsDataSource.getGroupStatus()
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        try await groupsDataSource.getTeamSummary()
    }
}
