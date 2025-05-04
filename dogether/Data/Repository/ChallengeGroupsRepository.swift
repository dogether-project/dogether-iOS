//
//  ChallengeGroupsRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepository: ChallengeGroupsProtocol {
    private let challengeGroupsDataSource: ChallengeGroupsDataSource
    
    init(challengeGroupsDataSource: ChallengeGroupsDataSource = .shared) {
        self.challengeGroupsDataSource = challengeGroupsDataSource
    }
    
    func createTodos(createTodosRequest: CreateTodosRequest) async throws {
        try await challengeGroupsDataSource.createTodos(createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await challengeGroupsDataSource.getMyTodos(date: date, status: status)
    }
    
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse {
        try await challengeGroupsDataSource.getMemberTodos(groupId: groupId, memberId: memberId)
    }
}
