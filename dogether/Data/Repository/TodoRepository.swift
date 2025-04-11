//
//  TodoRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class TodoRepository: TodoProtocol {
    private let todosDataSource: TodosDataSource
    
    init(todosDataSource: TodosDataSource = .shared) {
        self.todosDataSource = todosDataSource
    }
    
    func createTodos(createTodosRequest: CreateTodosRequest) async throws {
        try await todosDataSource.createTodos(createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await todosDataSource.getMyTodos(date: date, status: status)
    }
}
