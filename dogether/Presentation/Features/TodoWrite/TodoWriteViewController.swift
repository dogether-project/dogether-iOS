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
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        todoWritePage.delegate = self
        
        pages = [todoWritePage]
        
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
//        todoTextField.becomeFirstResponder()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? TodoWriteViewDatas else { return }
        viewModel.todoWriteViewDatas.accept(datas)
    }
    
    override func bindViewModel() {
        viewModel.todoWriteViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: TodoWriteViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                todoWritePage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
    }
    
    
    override func configureAction() {
//        navigationHeader.delegate = self
//        
//        todoTextField.delegate = self
//        todoTextField.addAction(
//            UIAction { [weak self] _ in
//                guard let self else { return }
//                viewModel.updateTodo(todo: todoTextField.text)
//                updateTextField()
//                updateAddButtonStatus()
//            }, for: .editingChanged
//        )
//        
//        addButton.addAction(
//            UIAction { [weak self] _ in
//                guard let self else { return }
//                if viewModel.addTodo() {
//                    todoTableView.reloadData()
//                    dismissKeyboard()
//                    viewModel.updateTodo(todo: "")
//                    updateTextField()
//                    updateView()
//                    updateAddButtonStatus()
//                }
//            }, for: .touchUpInside
//        )
//        
//        saveButton.addAction(
//            UIAction { [weak self] _ in
//                guard let self else { return }
//                self.coordinator?.showPopup(self, type: .alert, alertType: .saveTodo) { [weak self] _ in
//                    guard let self else { return }
//                    trySaveTodo()
//                }
//            }, for: .touchUpInside
//        )
//
//        todoTableView.delegate = self
//        todoTableView.dataSource = self
//        todoTableView.register(TodoWriteTableViewCell.self, forCellReuseIdentifier: TodoWriteTableViewCell.identifier)
    }
    
}

//extension TodoWriteViewController {
//    private func updateView() {
//        updateTextField()
//        updateTodoLimitLabel()
//        emptyListView.isHidden = !viewModel.todos.isEmpty
//        todoTableView.isHidden = viewModel.todos.isEmpty
//        todoTableView.reloadData()
//        
//        saveButton.setButtonStatus(status: viewModel.todos.isEmpty ? .disabled : .enabled) // FIXME: 새로 작성한 투두 없을땐 disable되게 수정필요 (기존에 작성된 투두가 있을 경우 항상 enable상태임)
//    }
//    
//    private func updateTextField() {
//        todoTextField.text = viewModel.todo
//        let canAddTodo = viewModel.todos.count < viewModel.maximumTodoCount
//        todoTextField.isEnabled = canAddTodo
//        todoTextField.attributedPlaceholder = NSAttributedString(
//            string: canAddTodo ? "예) 30분 걷기, 책 20페이지 읽기" : "모든 투두를 작성했어요!",
//            attributes: [.foregroundColor: canAddTodo ? UIColor.grey300 : UIColor.grey400]
//        )
//        todoTextField.backgroundColor = canAddTodo ? .grey800 : .grey500
//        todoLimitTextCount.isHidden = !canAddTodo
//
//        todoLimitTextCount.attributedText = makeAttributedText(
//            current: "\(viewModel.todo.count)",
//            maximum: "/\(viewModel.todoMaxLength)",
//            currentColor: .blue300,
//            maximumColor: .grey500
//        )
//    }
//    
//    private func updateTodoLimitLabel() {
//        let current = "\(viewModel.todos.count)"
//        let maximum = "/\(viewModel.maximumTodoCount)"
//        
//        todoLimitLabel.attributedText = makeAttributedText(
//            prefix: "추가 가능 투두 ",
//            current: current,
//            maximum: maximum,
//            currentColor: .blue300,
//            maximumColor: .grey600,
//            baseAttributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
//        )
//    }
//    
//    private func makeAttributedText(
//        prefix: String = "",
//        current: String,
//        maximum: String,
//        currentColor: UIColor,
//        maximumColor: UIColor,
//        baseAttributes: [NSAttributedString.Key: Any]? = nil
//    ) -> NSAttributedString {
//        let fullText = "\(prefix)\(current)\(maximum)"
//        let attributedText = NSMutableAttributedString(string: fullText, attributes: baseAttributes)
//        
//        if let range = fullText.range(of: current) {
//            let nsRange = NSRange(range, in: fullText)
//            attributedText.addAttribute(.foregroundColor, value: currentColor, range: nsRange)
//        }
//        
//        if let range = fullText.range(of: maximum) {
//            let nsRange = NSRange(range, in: fullText)
//            attributedText.addAttribute(.foregroundColor, value: maximumColor, range: nsRange)
//        }
//        
//        return attributedText
//    }
//    
//    private func updateAddButtonStatus() {
//        let trimmed = todoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        addButton.isEnabled = !trimmed.isEmpty
//        addButton.backgroundColor = trimmed.isEmpty ? .grey600 : .blue300
//        addButton.tintColor = trimmed.isEmpty ? .grey400 : .grey900
//    }
//}
//
//// MARK: - aboout tableView
//extension TodoWriteViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.todos.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: TodoWriteTableViewCell.identifier,
//            for: indexPath
//        ) as? TodoWriteTableViewCell else { return UITableViewCell() }
//        
//        cell.setExtraInfo(todo: viewModel.todos[indexPath.row], index: indexPath.row) { [weak self] index in
//            guard let self else { return }
//            viewModel.removeTodo(index)
//            todoTableView.reloadData()
//            updateView()
//        }
//        
//        return cell
//    }
//}
//
//// MARK: - abount keyboard (UITextFieldDelegate)
//extension TodoWriteViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard addButton.isEnabled else {
//            return false
//        }
//        if viewModel.addTodo() {
//            todoTableView.reloadData()
//            viewModel.updateTodo(todo: "")
//            updateTextField()
//            updateView()
//            updateAddButtonStatus()
//        }
//        return true
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        todoTextField.layer.borderWidth = 1.5
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        todoTextField.layer.borderWidth = 0
//    }
//    
//    @objc private func dismissKeyboard() { view.endEditing(true) }
//}

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

// MARK: - delegate
protocol TodoWriteDelegate {
    
}

extension TodoWriteViewController: TodoWriteDelegate {
    
}
