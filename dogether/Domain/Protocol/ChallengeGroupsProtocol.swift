//
//  ChallengeGroupsProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

protocol ChallengeGroupsProtocol {
    func createTodos(createTodosRequest: CreateTodosRequest) async throws
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse
}
