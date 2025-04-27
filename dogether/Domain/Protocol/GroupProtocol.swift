//
//  GroupProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupProtocol {
    func getIsJoining() async throws -> GetIsJoiningResponse
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse
    
    func getGroups() async throws -> GetGroupsResponse
    func getGroupInfo() async throws -> GetGroupInfoResponse
    func getGroupStatus() async throws -> GetGroupStatusResponse
    func getMyGroup() async throws -> GetMyGroupResponse
    func getRanking(groupId: String) async throws -> GetRankingResponse
}
