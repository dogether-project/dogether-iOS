//
//  TodoWritePage.swift
//  dogether
//
//  Created by seungyooooong on 10/3/25.
//

import UIKit

final class TodoWritePage: BasePage {
    var delegate: TodoWriteDelegate? {
        didSet {
            addTapAction { [weak self] in
                guard let self else { return }
                endEditing(true)
            }
            
            todoTextField.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.updateTodoAction(todo: todoTextField.text, todoMaxLength: todoMaxLength)
                }, for: .editingChanged
            )
            
            addButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.addTodoAction(todoMaxCount: todoMaxCount)
                }, for: .touchUpInside
            )
            
            saveButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.saveTodoAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "투두 작성")
    
    private let dateLabel = UILabel()
    private let todoLimitLabel = UILabel()
    
    private let todoTextField = UITextField()
    private let todoLimitTextCount = UILabel()
    
    private let addButton = UIButton()
    private let addButtonImageView = UIImageView()
    
    private let emptyListView = {
        let imageView = UIImageView(image: .embarrassedDosik)
        imageView.contentMode = .scaleAspectFit
        
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
        
        stackView.setCustomSpacing(17, after: imageView)
        stackView.setCustomSpacing(0, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(129)
            $0.height.equalTo(148)
        }
        
        return stackView
    }()
    private let todoTableView = UITableView()
    
    private let saveButton = DogetherButton(title: "투두 저장", status: .disabled)
    
    private let todoMaxCount: Int = 10
    private let todoMaxLength: Int = 20
    private(set) var currentTodo: String?
    private(set) var currentTodos: [WriteTodoEntity]?
    private(set) var currentIsShowKeyboard: Bool?
    
    override func configureView() {
        dateLabel.attributedText = NSAttributedString(
            string: DateFormatterManager.formattedDate(format: .MdE),
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        dateLabel.textColor = .grey400
        todoLimitLabel.textColor = .grey0
        
        todoTextField.font = Fonts.body1S
        todoTextField.tintColor = .blue300
        todoTextField.textColor = .grey0
        todoTextField.returnKeyType = .done
        todoTextField.borderStyle = .none
        todoTextField.backgroundColor = .grey800
        todoTextField.layer.cornerRadius = 12
        todoTextField.layer.borderWidth = 0
        todoTextField.layer.borderColor = UIColor.blue300.cgColor
        todoTextField.becomeFirstResponder()
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: todoTextField.frame.height))
        todoTextField.leftView = leftPaddingView
        todoTextField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: todoTextField.frame.height))
        todoTextField.rightView = rightPaddingView
        todoTextField.rightViewMode = .always
        
        todoLimitTextCount.textColor = .grey500
        todoLimitTextCount.font = Fonts.smallS
        
        addButton.backgroundColor = .grey600
        addButton.layer.cornerRadius = 8
        addButton.tintColor = .grey400
        
        addButtonImageView.image = .plus.withRenderingMode(.alwaysTemplate)
        addButtonImageView.isUserInteractionEnabled = false
        
        todoTableView.isHidden = true
        todoTableView.backgroundColor = .clear
        todoTableView.separatorStyle = .none
        todoTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate

        todoTextField.delegate = self

        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoWriteTableViewCell.self, forCellReuseIdentifier: TodoWriteTableViewCell.identifier)
        
    }
    
    override func configureHierarchy() {
        addButton.addSubview(addButtonImageView)
        
        [ navigationHeader, dateLabel, todoLimitLabel,
          todoTextField, todoLimitTextCount, addButton,
          emptyListView, todoTableView, saveButton
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoLimitLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoTextField.snp.makeConstraints {
            $0.top.equalTo(todoLimitLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(72)
            $0.height.equalTo(50)
        }
        
        todoLimitTextCount.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.trailing.equalTo(todoTextField.snp.trailing).inset(8)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.leading.equalTo(todoTextField.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(48)
        }
        
        addButtonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(todoTextField.snp.bottom).offset(101)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(22)
            $0.bottom.equalTo(saveButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? TodoWriteViewDatas {
            if currentTodo != datas.todo {
                currentTodo = datas.todo
                
                updateTextField()
                updateAddButtonStatus()
            }
            
            if currentTodos != datas.todos {
                currentTodos = datas.todos
                
                updateTodoLimitLabel()
                
                emptyListView.isHidden = !datas.todos.isEmpty
                todoTableView.isHidden = datas.todos.isEmpty
                todoTableView.reloadData()
                
                saveButton.setButtonStatus(status: datas.todos.map { $0.enabled }.isEmpty ? .disabled : .enabled)

            }
            
            if currentIsShowKeyboard != datas.isShowKeyboard {
                currentIsShowKeyboard = datas.isShowKeyboard
                
                todoTextField.layer.borderWidth = datas.isShowKeyboard ? 1.5 : 0
            }
        }
    }
}

extension TodoWritePage {
    private func updateTextField() {
        todoTextField.text = currentTodo
        let canAddTodo = (currentTodos ?? []).count < todoMaxCount
        todoTextField.isEnabled = canAddTodo
        todoTextField.attributedPlaceholder = NSAttributedString(
            string: canAddTodo ? "예) 30분 걷기, 책 20페이지 읽기" : "모든 투두를 작성했어요!",
            attributes: [.foregroundColor: canAddTodo ? UIColor.grey300 : UIColor.grey400]
        )
        todoTextField.backgroundColor = canAddTodo ? .grey800 : .grey500
        todoLimitTextCount.isHidden = !canAddTodo

        todoLimitTextCount.attributedText = makeAttributedText(
            current: "\((currentTodo ?? "").count)",
            maximum: "/\(todoMaxLength)",
            currentColor: .blue300,
            maximumColor: .grey500
        )
    }
    
    private func updateAddButtonStatus() {
        let trimmed = (currentTodo ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        addButton.isEnabled = !trimmed.isEmpty
        addButton.backgroundColor = trimmed.isEmpty ? .grey600 : .blue300
        addButton.tintColor = trimmed.isEmpty ? .grey400 : .grey900
    }
    
    private func updateTodoLimitLabel() {
        let current = "\((currentTodos ?? []).count)"
        
        todoLimitLabel.attributedText = makeAttributedText(
            prefix: "추가 가능 투두 ",
            current: current,
            maximum: "/\(todoMaxCount)",
            currentColor: .blue300,
            maximumColor: .grey600,
            baseAttributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .left)
        )
    }
    
    private func makeAttributedText(
        prefix: String = "",
        current: String,
        maximum: String,
        currentColor: UIColor,
        maximumColor: UIColor,
        baseAttributes: [NSAttributedString.Key: Any]? = nil
    ) -> NSAttributedString {
        let fullText = "\(prefix)\(current)\(maximum)"
        let attributedText = NSMutableAttributedString(string: fullText, attributes: baseAttributes)
        
        if let range = fullText.range(of: current) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: currentColor, range: nsRange)
        }
        
        if let range = fullText.range(of: maximum) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: maximumColor, range: nsRange)
        }
        
        return attributedText
    }
}

// MARK: - aboout tableView
extension TodoWritePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentTodos ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoWriteTableViewCell.identifier,
            for: indexPath
        ) as? TodoWriteTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(todo: (currentTodos ?? [])[indexPath.row], index: indexPath.row) { [weak self] index in
            guard let self else { return }
            delegate?.removeTodoAction(index: index)
        }
        
        return cell
    }
}

// MARK: - abount keyboard (UITextFieldDelegate)
extension TodoWritePage: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard addButton.isEnabled else { return false }
        delegate?.addTodoAction(todoMaxCount: todoMaxCount)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.updateIsShowKeyboardAction(isShowKeyboard: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateIsShowKeyboardAction(isShowKeyboard: false)
    }
    
    @objc private func dismissKeyboard() { endEditing(true) }
}
