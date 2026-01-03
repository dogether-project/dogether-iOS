//
//  TodosDataSource.swift
//  dogether
//
//  Created by seungyooooong on 1/3/26.
//

import Foundation

final class TodosDataSource {
    static let shared = TodosDataSource()
    
    private init() { }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await NetworkManager.shared.request(
            TodosRouter.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
        )
    }
    
    func remindTodo(todoId: String, remindTodoRequest: RemindTodoRequest) async throws {
        try await NetworkManager.shared.request(
            TodosRouter.remindTodo(todoId: todoId, remindTodoRequest: remindTodoRequest)
        )
    }
}
