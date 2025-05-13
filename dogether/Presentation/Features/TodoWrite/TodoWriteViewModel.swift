//
//  TodoWriteViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class TodoWriteViewModel {
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    
    let maximumTodoCount: Int = 10
    let todoMaxLength: Int = 20
    
    private(set) var todo: String = ""
    private(set) var todos: [String] = []
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
    }
    
}

extension TodoWriteViewModel {
    func updateTodo(todo text: String?) {
        todo = text ?? ""
        
        if todo.count > todoMaxLength {
            todo = String(todo.prefix(todoMaxLength))
        }
    }
    
    func addTodo() -> Bool {
        if todo.isEmpty || todos.count >= maximumTodoCount { return false }
        
        todos.insert(todo, at: 0)
        return true
    }
    
    func removeTodo(_ index: Int) {
        guard index < todos.count else { return }
        todos.remove(at: index)
    }
    
    func createTodos() async throws {
        try await challengeGroupsUseCase.createTodos(todos: todos)
    }
}
