//
//  ChallengeGroupsUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsUseCase {
    private let repository: ChallengeGroupsProtocol
    
    init(repository: ChallengeGroupsProtocol) {
        self.repository = repository
    }
    
    func createTodos(groupId: Int, todos: [WriteTodoEntity]) async throws {
        let createTodosRequest = CreateTodosRequest(todos: todos.reversed().filter { $0.enabled }.map { $0.content })
        try await repository.createTodos(groupId: String(groupId), createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(groupId: Int, date: String) async throws -> [TodoEntity] {
        try await repository.getMyTodos(groupId: String(groupId), date: date).map { $0.with(createdAt: date) }
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, isMine: Bool, todos: [TodoEntity]) {
        try await repository.getMemberTodos(groupId: groupId, memberId: memberId)
    }
    
    func readTodo(todo: TodoEntity) async throws {
        guard let todoHistoryId = todo.historyId else { return }
        // MARK: 이미 thumbnailStatus 가 done인 투두는 read API 호출할 필요 x
        if todo.thumbnailStatus == .done { return }
        try await repository.readTodo(todoHistoryId: String(todoHistoryId))
    }
}
