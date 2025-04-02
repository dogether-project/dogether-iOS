//
//  PopupRepository.swift
//  dogether
//
//  Created by seungyooooong on 4/2/25.
//

import Foundation

final class PopupRepository: PopupProtocol {
    private let todosDataSource: TodosDataSource
    
    init(todosDataSource: TodosDataSource = .shared) {
        self.todosDataSource = todosDataSource
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await todosDataSource.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
    }
}
