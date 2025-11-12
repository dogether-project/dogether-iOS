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
        pages = [todoWritePage]
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateIsFirstResponder(isFirstResponder: true)
    }
    
    override func setViewDatas() {
        if let datas = datas as? TodoWriteViewDatas {
            viewModel.todoWriteViewDatas.accept(datas)
        }
        
        bind(viewModel.todoWriteViewDatas)
    }
    
    override func bindAction() {
        todoWritePage.todoChanged
            .emit(onNext: { [weak self] (text, maxLen) in
                guard let self else { return }
                viewModel.updateTodo(todo: text, todoMaxLength: maxLen)
            })
            .disposed(by: disposeBag)
        
        todoWritePage.addTap
            .emit(onNext: { [weak self] maxCount in
                guard let self else { return }
                viewModel.addTodo(todoMaxCount: maxCount)
            })
            .disposed(by: disposeBag)
        
        todoWritePage.removeTap
            .emit(onNext: { [weak self] index in
                guard let self else { return }
                viewModel.removeTodo(index: index)
            })
            .disposed(by: disposeBag)
        
        todoWritePage.saveTap
            .emit(onNext: { [weak self] in
                guard let self else { return }
                coordinator?.showPopup(
                    self,
                    type: .alert,
                    alertType: .saveTodo
                ) { [weak self] _ in
                    self?.trySaveTodo()
                }
            })
            .disposed(by: disposeBag)
        
        
        todoWritePage.keyboardState
            .emit(onNext: { [weak self] isShow in
                guard let self else { return }
                viewModel.updateIsShowKeyboard(isShowKeyboard: isShow)
            })
            .disposed(by: disposeBag)
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
