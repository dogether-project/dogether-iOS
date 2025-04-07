//
//  TodoUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class TodoUseCase {
    private let repository: TodoProtocol
    
    init(repository: TodoProtocol) {
        self.repository = repository
    }
    
    func createTodos(todos: [String]) async throws {
        let createTodosRequest = CreateTodosRequest(todos: todos)
        try await repository.createTodos(createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> [TodoInfo] {
        let response = try await repository.getMyTodos(date: date, status: status)
        return response.todos
    }
}
