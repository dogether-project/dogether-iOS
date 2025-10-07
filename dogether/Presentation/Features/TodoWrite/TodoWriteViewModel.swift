//
//  TodoWriteViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

import RxRelay

final class TodoWriteViewModel {
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    private let todoWriteUseCase: TodoWriteUseCase
    
    private(set) var todoWriteViewDatas = BehaviorRelay<TodoWriteViewDatas>(value: TodoWriteViewDatas())
    
    init() {
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
        self.todoWriteUseCase = TodoWriteUseCase()
    }
    
}

extension TodoWriteViewModel {
    func updateIsShowKeyboard(isShowKeyboard: Bool) {
        todoWriteViewDatas.update { $0.isShowKeyboard = isShowKeyboard }
    }
    
    func updateTodo(todo: String?, todoMaxLength: Int) {
        todoWriteViewDatas.update {
            $0.todo = todoWriteUseCase.prefixTodo(todo: todo, todoMaxLength: todoMaxLength)
        }
    }
    
    func addTodo(todoMaxCount: Int) {
        let todo = todoWriteViewDatas.value.todo
        let todos = todoWriteViewDatas.value.todos
        if todo.isEmpty || todos.count >= todoMaxCount { return }

        todoWriteViewDatas.update {
            $0.todo = ""
            $0.todos = [WriteTodoEntity(content: todo)] + todos
            $0.isShowKeyboard = false
        }
    }
    
    func removeTodo(index: Int) {
        var todos = todoWriteViewDatas.value.todos
        guard index < todos.count else { return }

        todos.remove(at: index)
        todoWriteViewDatas.update { $0.todos = todos }
    }
    
    func createTodos() async throws {
        try await challengeGroupsUseCase.createTodos(
            groupId: todoWriteViewDatas.value.groupId,
            todos: todoWriteViewDatas.value.todos
        )
    }
}
