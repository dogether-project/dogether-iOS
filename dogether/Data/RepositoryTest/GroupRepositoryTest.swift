//
//  GroupRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class GroupRepositoryTest: GroupProtocol {
    func getIsJoining() async throws -> GetIsJoiningResponse {
//        return GetIsJoiningResponse(isJoining: false)
        return GetIsJoiningResponse(isJoining: true)
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        return CreateGroupResponse(joinCode: "000000")
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        return JoinGroupResponse(name: "testGroup", maximumMemberCount: 10, startAt: "2025-01-01", endAt: "2025-01-04", durationOption: 3)
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        return GetGroupInfoResponse(
            name: "Test Group Name",
            duration: 3,
            joinCode: "000000",
            maximumTodoCount: 10,
            endAt: "25.01.01",
            remainingDays: 2
        )
    }
    
    func getGroupStatus() async throws -> GetGroupStatusResponse {
//        return GetGroupStatusResponse(status: "READY")
        return GetGroupStatusResponse(status: "RUNNING")
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        let rankings = (1 ... 20).map { RankingModel(rank: $0, name: "testName \($0)", certificationRate: Double($0)) }
        return GetTeamSummaryResponse(ranking: rankings)
    }
}
