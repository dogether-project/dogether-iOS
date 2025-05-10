//
//  GroupUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupUseCase {
    private let repository: GroupProtocol
    
    init(repository: GroupProtocol) {
        self.repository = repository
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> String {
        let response = try await repository.createGroup(createGroupRequest: createGroupRequest)
        return response.joinCode
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> GroupInfo {
        let response = try await repository.joinGroup(joinGroupRequest: joinGroupRequest)
        // FIXME: API 수정 후 내용 반영
        return GroupInfo(
            name: response.name,
            duration: response.durationOption,
            joinCode: joinGroupRequest.joinCode,
            maximumTodoCount: 10,
            endAt: response.endAt,
            remainingDays: 0
        )
    }
    
    func getGroupInfo() async throws -> GroupInfo {
        let response = try await repository.getGroupInfo()
        return GroupInfo(
            name: response.name,
            duration: response.duration,
            joinCode: response.joinCode,
            maximumTodoCount: response.maximumTodoCount,
            endAt: response.endAt,
            remainingDays: response.remainingDays
        )
    }
    
    func getGroupStatus() async throws -> String {
        let response = try await repository.getGroupStatus()
        return response.status
    }
    
    func getRankings(groupId: Int) async throws -> [RankingModel] {
        let response = try await repository.getRanking(groupId: String(groupId))
        return response.ranking.map {
            RankingModel(
                memberId: $0.memberId,
                rank: $0.rank,
                profileImageUrl: $0.profileImageUrl,
                name: $0.name,
                historyReadStatus: HistoryReadStatus(rawValue: $0.historyReadStatus),
                achievementRate: $0.achievementRate)
        }
    }
}
