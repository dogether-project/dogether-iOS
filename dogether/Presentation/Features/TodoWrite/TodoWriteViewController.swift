//
//  TodoWriteViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

final class TodoWriteViewController: BaseViewController {
    private let viewModel = TodoWriteViewModel()
    
    private let navigationHeader = NavigationHeader(title: "투두 작성")
    
    private let dateLabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: DateFormatterManager.formattedDate(format: .MdE),
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
        )
        label.textColor = .grey0
        return label
    }()
    
    private let todoTextField = {
        let textField = UITextField()
        textField.font = Fonts.body1S
        textField.tintColor = .blue300
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.backgroundColor = .grey800
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 92, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let todoLimitTextCount = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.smallS
        return label
    }()
    
    private let addButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView()
        imageView.image = .plus.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey100
        imageView.isUserInteractionEnabled = false
        
        button.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        return button
    }()
    
    private let noticeView = {
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한 번 저장한 투두는 수정 및 삭제할 수 없어요"
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.grey600.cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return stackView
    }()
    
    private let emptyListView = {
        let imageView = UIImageView(image: .comment)
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "아직 작성된 투두가 없어요",
            attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
        )
        titleLabel.textColor = .grey400
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: "오늘 하루 이루고 싶은 목표를 입력해보세요!",
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .center)
        )
        subTitleLabel.textColor = .grey400
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.setCustomSpacing(15, after: imageView)
        stackView.setCustomSpacing(4, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(54)
        }
        
        return stackView
    }()
    
    private let todoTableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let saveButton = DogetherButton(title: "투두 저장", status: .disabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTextField.becomeFirstResponder()
    }
    
    override func configureView() {
        updateView()
        
        todoTextField.attributedPlaceholder = NSAttributedString(
            string: "투두를 입력해주세요 (최대 \(viewModel.maximumTodoCount)개)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grey300]
        )
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        todoTextField.delegate = self
        todoTextField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.updateTodo(todo: todoTextField.text)
                updateTextField()
            }, for: .editingChanged
        )
        
        addButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if viewModel.addTodo() {
                    todoTableView.reloadData()
                    dismissKeyboard()
                    viewModel.updateTodo(todo: "")
                    updateTextField()
                    updateView()
                }
            }, for: .touchUpInside
        )
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    try await self.viewModel.createTodos()
                    await MainActor.run {
                        self.coordinator?.popViewController()
                    }
                }
            }, for: .touchUpInside
        )
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoWriteTableViewCell.self, forCellReuseIdentifier: TodoWriteTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [ navigationHeader, dateLabel,
          todoTextField, todoLimitTextCount, addButton,
          noticeView, emptyListView, todoTableView, saveButton
        ].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        todoLimitTextCount.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.trailing.equalTo(addButton.snp.leading).offset(-5)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.trailing.equalTo(todoTextField.snp.trailing).offset(-8)
            $0.width.height.equalTo(40)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noticeView.snp.bottom).offset(94)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom).offset(22)
            $0.bottom.equalTo(saveButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension TodoWriteViewController {
    private func updateView() {
        updateTextField()
        
        emptyListView.isHidden = !viewModel.todos.isEmpty
        todoTableView.isHidden = viewModel.todos.isEmpty
        todoTableView.reloadData()
        
        saveButton.setButtonStatus(status: viewModel.todos.isEmpty ? .disabled : .enabled)
    }
    
    private func updateTextField() {
        todoTextField.text = viewModel.todo
        todoLimitTextCount.text = "\(viewModel.todo.count)/\(viewModel.todoMaxLength)"
    }
}

// MARK: - aboout tableView
extension TodoWriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoWriteTableViewCell.identifier,
            for: indexPath
        ) as? TodoWriteTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(text: viewModel.todos[indexPath.row], index: indexPath.row) { [weak self] index in
            guard let self else { return }
            viewModel.removeTodo(index)
            todoTableView.reloadData()
            updateView()
        }
        
        return cell
    }
}

// MARK: - abount keyboard (UITextFieldDelegate)
extension TodoWriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        todoTextField.layer.borderColor = UIColor.blue300.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
