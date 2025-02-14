//
//  TodoWriteViewController.swift
//  dogether
//
//  Created by 박지은 on 2/13/25.
//

import UIKit

final class TodoWriteViewController: BaseViewController {
    
    private let maxToDoCount = 10
    
    private var toDoList: [String] = [] {
        didSet {
            updateView ()
        }
    }
    
    private let dateLabel = {
        let label = UILabel()
        label.text = DateFormatterManager.today()
        label.font = Fonts.head1B
        return label
    }()
    
    private lazy var toDoTextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .grey800
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.delegate = self
        
        // placeholder 스타일
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.grey300,
            .font: Fonts.body1S
        ]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "투두를 입력해주세요 (최대 10개)",
            attributes: attributes
        )
        
        // placeholder 왼쪽 여백
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        
        return textField
    }()
    
    private let toDoLimitTextCount = {
        let label = UILabel()
        label.text = "0/20"
        label.font = Fonts.smallS
        label.textColor = .grey300
        return label
    }()
    
    // TODO: - 아이콘 변경
    private lazy var addButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        return button
    }()
    
    private let infoView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let infoIcon = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "exclamationmark.circle")
        icon.tintColor = .grey400
        return icon
    }()
    
    private let infoLabel = {
        let label = UILabel()
        label.text = "한 번 저장한 투두는 수정 및 삭제할 수 없어요"
        label.font = Fonts.body2S
        label.textColor = .grey400
        return label
    }()
    
    // TODO: - 수정 필요
    private let emptyView = {
        let view = UIView()
        let label = UILabel()
        label.text = "아직 작성된 투두가 없어요"
        label.textColor = .grey400
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return view
    }()
    
    // TODO: - 테이블뷰셀 스타일 변경
    private lazy var toDoTableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var saveButton = {
        let button = UIButton()
        button.setTitle("투두 저장", for: .normal)
        button.backgroundColor = .grey500
        button.setTitleColor(.grey400, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGesture()
    }
    
    override func configureHierarchy() {
        [dateLabel, toDoTextField, toDoLimitTextCount, addButton, infoView, emptyView, toDoTableView, saveButton].forEach {
            view.addSubview($0)
        }
        
        [infoIcon, infoLabel].forEach {
            infoView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
            $0.leading.equalToSuperview().offset(16)
        }
        
        toDoTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        toDoLimitTextCount.snp.makeConstraints {
            $0.centerY.equalTo(toDoTextField)
            $0.trailing.equalTo(addButton.snp.leading).offset(-8)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(toDoTextField)
            $0.trailing.equalTo(toDoTextField.snp.trailing).offset(-8)
            $0.width.height.equalTo(40)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(toDoTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(toDoTextField)
            $0.height.equalTo(40)
        }
        
        infoIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(infoIcon.snp.trailing).offset(8)
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        toDoTableView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        navigationItem.title = "투두 작성"
    }
    
    private func updateView() {
        emptyView.isHidden = !toDoList.isEmpty
        toDoTableView.isHidden = toDoList.isEmpty
        toDoTableView.reloadData()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateSaveButtonState() {
        if saveButton.isEnabled {
            saveButton.backgroundColor = .blue300
            saveButton.setTitleColor(.grey800, for: .normal)
        } else {
            saveButton.backgroundColor = .grey500
            saveButton.setTitleColor(.grey400, for: .normal)
        }
    }
    
    @objc private func saveButtonClicked() {
        print("투두 저장 버튼 클릭")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addTodo() {
        guard let text = toDoTextField.text, !text.isEmpty, text.count <= 20 else { return }
        guard toDoList.count < maxToDoCount else { return }
        
        toDoList.insert(text, at: 0)
        toDoTextField.text = ""
        toDoLimitTextCount.text = "0/20"
        saveButton.isEnabled = true
        updateSaveButtonState()
    }
    
    // 텍스트필드 입력한 문자 수
    @objc private func textFieldDidChange() {
        toDoLimitTextCount.text = "\(toDoTextField.text?.count ?? 0)/20"
    }
    
    // 텍스트필드 입력 시 borderColor
    @objc private func textFieldDidBegin() {
        toDoTextField.layer.borderColor = UIColor.blue300.cgColor
    }
    
    // 텍스트필드 입력 완료 시
    @objc private func textFieldDidEnd() {
        toDoTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    // 엔터 액션에도 투두 추가
    @objc private func textFieldReturnPressed(_ textField: UITextField) {
        addTodo()
    }
}

extension TodoWriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier,
                                                 for: indexPath) as! ToDoTableViewCell
        
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        cell.todoLabel.text = toDoList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension TodoWriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTodo()
        return true
    }
}

class ModalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "modal sheet"
        label.font = Fonts.body1B
        label.textColor = .black
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
