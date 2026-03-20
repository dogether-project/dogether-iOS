//
//  TodosRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 1/3/26.
//

import Foundation

final class TodosRepositoryTest: TodosProtocol {
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws { }
    
    func remindTodo(todoId: String, remindTodoRequest: RemindTodoRequest) async throws { }
}
