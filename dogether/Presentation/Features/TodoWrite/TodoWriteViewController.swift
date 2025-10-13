//
//  TodoWriteViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TodoWriteViewController: BaseViewController {
    private let todoWritePage = TodoWritePage()
    private let viewModel = TodoWriteViewModel()
    
    override func viewDidLoad() {
        todoWritePage.delegate = self
        
        pages = [todoWritePage]
        
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? TodoWriteViewDatas else { return }
        viewModel.todoWriteViewDatas.accept(datas)
    }
    
    override func bindViewModel() {
        bind(viewModel.todoWriteViewDatas)
    }
}

// MARK: - delegate
protocol TodoWriteDelegate {
    func updateIsShowKeyboardAction(isShowKeyboard: Bool)
    func updateTodoAction(todo: String?, todoMaxLength: Int)
    func addTodoAction(todoMaxCount: Int)
    func removeTodoAction(index: Int)
    func saveTodoAction()
}

extension TodoWriteViewController: TodoWriteDelegate {
    func updateIsShowKeyboardAction(isShowKeyboard: Bool) {
        viewModel.updateIsShowKeyboard(isShowKeyboard: isShowKeyboard)
    }
    
    func updateTodoAction(todo: String?, todoMaxLength: Int) {
        viewModel.updateTodo(todo: todo, todoMaxLength: todoMaxLength)
    }
    
    func addTodoAction(todoMaxCount: Int) {
        viewModel.addTodo(todoMaxCount: todoMaxCount)
    }
    
    func removeTodoAction(index: Int) {
        viewModel.removeTodo(index: index)
    }
    
    func saveTodoAction() {
        coordinator?.showPopup(self, type: .alert, alertType: .saveTodo) { [weak self] _ in
            guard let self else { return }
            trySaveTodo()
        }
    }
}

extension TodoWriteViewController {
    private func trySaveTodo() {
        Task {
            do {
                try await self.viewModel.createTodos()
                await MainActor.run {
                    self.coordinator?.popViewController()
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: self.coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        trySaveTodo()
                    }
                )
            }
        }
    }
}
