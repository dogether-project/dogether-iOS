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
    
    // TODO: - + 아이콘 말고 엔터액션에서도 투두 추가되게 하기
    private let toDoTextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        // placeholder 스타일
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.grey300,
            .font: Fonts.body1S
        ]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "투두를 입력해주세요 (최대 10개)",
            attributes: attributes
        )
        
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .grey800
        
        // placeholder 왼쪽 여백
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // TODO: - 작성된 글자수에 맞춰서 숫자 변동
    private let toDoLimitTextCount = {
        let label = UILabel()
        label.text = "0/21"
        label.font = Fonts.smallS
        label.textColor = .grey300
        return label
    }()
    
    // TODO: - 아이콘 변경
    private let addButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        
    }()
    
    private let saveButton = {
        let button = UIButton()
        button.setTitle("투두 저장", for: .normal)
        button.backgroundColor = .grey500
        button.setTitleColor(.grey400, for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
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
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
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
    
    @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
    
    @objc private func addTodo() {
        guard let text = toDoTextField.text, !text.isEmpty, text.count <= 21 else { return }
        guard toDoList.count < maxToDoCount else { return }
        
        toDoList.insert(text, at: 0)
        toDoTextField.text = ""
    }
}

extension TodoWriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row]
        return cell
    }
}
