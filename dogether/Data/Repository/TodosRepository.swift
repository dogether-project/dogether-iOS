//
//  TodosRepository.swift
//  dogether
//
//  Created by seungyooooong on 1/3/26.
//

import Foundation

final class TodosRepository: TodosProtocol {
    private let todosDataSource: TodosDataSource
    
    init(todosDataSource: TodosDataSource = .shared) {
        self.todosDataSource = todosDataSource
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await todosDataSource.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
    }
    
    func remindTodo(todoId: String, remindTodoRequest: RemindTodoRequest) async throws {
        try await todosDataSource.remindTodo(todoId: todoId, remindTodoRequest: remindTodoRequest)
    }
}
