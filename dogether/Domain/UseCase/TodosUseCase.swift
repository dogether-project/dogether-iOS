//
//  TodosUseCase.swift
//  dogether
//
//  Created by seungyooooong on 1/3/26.
//

import Foundation

final class TodosUseCase {
    private let repository: TodosProtocol
    
    init(repository: TodosProtocol) {
        self.repository = repository
    }
    
    func certifyTodo(todoId: Int, content: String, mediaUrl: String) async throws {
        let certifyTodoRequest = CertifyTodoRequest(content: content, mediaUrl: mediaUrl)
        try await repository.certifyTodo(todoId: String(todoId), certifyTodoRequest: certifyTodoRequest)
    }
    
    func remindTodo(remindType: RemindTypes, todoId: Int) async throws {
        let remindTodoRequest = RemindTodoRequest(reminderType: remindType.rawValue)
        try await repository.remindTodo(todoId: String(todoId), remindTodoRequest: remindTodoRequest)
    }
}
