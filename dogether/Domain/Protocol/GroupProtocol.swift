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
    
    func getGroupInfo() async throws -> GetGroupInfoResponse
    func getGroupStatus() async throws -> GetGroupStatusResponse
    func getTeamSummary() async throws -> GetTeamSummaryResponse
}
