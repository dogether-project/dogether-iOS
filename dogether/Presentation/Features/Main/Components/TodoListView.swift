//
//  TodoListView.swift
//  dogether
//
//  Created by seungyooooong on 5/9/25.
//

import UIKit

final class TodoListView: BaseView {
    var delegate: MainDelegate? {
        didSet {
            [allButton, waitButton, approveButton, rejectButton].forEach { $0.delegate = delegate }
        }
    }
    
    private(set) var currentFilter: FilterTypes?
    private(set) var currentTodoList: [TodoEntity]?
    
    private let allButton = FilterButton(type: .all)
    private let waitButton = FilterButton(type: .wait)
    private let rejectButton = FilterButton(type: .reject)
    private let approveButton = FilterButton(type: .approve)
    private let filterStackView = UIStackView()
    
    private let todoScrollView = UIScrollView()
    private let todoListStackView = UIStackView()
    
    private let emptyListImageView = UIImageView(image: .comment)
    private let emptyListLabel = UILabel()
    private let emptyListStackView = UIStackView()
    
    private let addTodoButton: UIButton =  UIButton(type: .system)
    
    override func configureView() {
        filterStackView.axis = .horizontal
        filterStackView.spacing = 8
        
        todoScrollView.bounces = false
        todoScrollView.showsVerticalScrollIndicator = false
        
        todoListStackView.axis = .vertical
        todoListStackView.spacing = 8
        todoListStackView.distribution = .fillEqually
        
        emptyListLabel.textColor = .grey400
        emptyListLabel.font = Fonts.head2B
        
        emptyListStackView.axis = .vertical
        emptyListStackView.spacing = 16
        emptyListStackView.alignment = .center
        
        addTodoButton.setTitleColor(.grey200, for: .normal)
        addTodoButton.titleLabel?.font = Fonts.body1S
        addTodoButton.backgroundColor = .clear
        addTodoButton.contentHorizontalAlignment = .center
        
        addTodoButton.setImage(.plusCircle, for: .normal)
        addTodoButton.tintColor = .grey200
        addTodoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        addTodoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        addTodoButton.imageView?.contentMode = .scaleAspectFit
        
        [allButton, waitButton, approveButton, rejectButton].forEach { filterStackView.addArrangedSubview($0) }
        [emptyListImageView, emptyListLabel].forEach { emptyListStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [todoScrollView, emptyListStackView, filterStackView].forEach { addSubview($0) }
        [todoListStackView].forEach { todoScrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        filterStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        todoScrollView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // MARK: item 대신 stackView에서 너비 지정
        }
        
        emptyListImageView.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(54)
        }
        
        emptyListLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        emptyListStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SheetViewDatas {
            if currentFilter == datas.filter && currentTodoList == datas.todoList { return }
            currentFilter = datas.filter
            currentTodoList = datas.todoList
            
            [allButton, waitButton, rejectButton, approveButton].forEach { $0.viewDidUpdate(datas.filter) }
            
            let isToday = datas.dateOffset == 0
            
            let currentTodoList = datas.todoList.filter {
                datas.filter == .all || datas.filter == FilterTypes(status: $0.status)
            }
            todoListStackView.isHidden = currentTodoList.isEmpty
            emptyListStackView.isHidden = !currentTodoList.isEmpty
            
            todoListStackView.subviews.forEach { todoListStackView.removeArrangedSubview($0) }
            currentTodoList
                .map { TodoListItemButton(todo: $0, isToday: isToday) }
                .forEach { todoListStackView.addArrangedSubview($0) }
            
            if datas.todoList.count < 10 && isToday {
                addTodoButton.setTitle("투두 추가하기 (\(datas.todoList.count)/10)", for: .normal)
                todoListStackView.addArrangedSubview(addTodoButton)
            }
            
            emptyListLabel.text = datas.filter.emptyDescription
        }
    }
}
