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
        // MARK: - TEST: 99999999 입력 시 에러 발생 테스트
        if joinGroupRequest.joinCode == "99999999" { throw NetworkError.unknown }
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
    
    func getRanking(groupId: String) async throws -> GetRankingResponse {
        let rankings = (1 ... 20).map {
            RankingResponse(
                memberId: $0,
                rank: $0,
                profileImageUrl: "",
                name: "testName \($0)",
                historyReadStatus: $0 % 3 == 0 ? "NULL" : $0 % 3 == 1 ? "READ_YET" : "READ_ALL",
                achievementRate: $0)
        }
        return GetRankingResponse(ranking: rankings)
    }
}
