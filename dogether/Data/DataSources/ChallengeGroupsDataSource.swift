//
//  ChallengeGroupsDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import Foundation

final class ChallengeGroupsDataSource {
    static let shared = ChallengeGroupsDataSource()
    
    private init() { }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.getMyTodos(date: date, status: status))
    }
    
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.getMemberTodos(groupId: groupId, memberId: memberId))
    }
    
    func createTodos(createTodosRequest: CreateTodosRequest) async throws {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.createTodos(createTodosRequest: createTodosRequest))
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest))
    }
}
