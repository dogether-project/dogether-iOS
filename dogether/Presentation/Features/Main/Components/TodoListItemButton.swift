//
//  TodoListItemButton.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class TodoListItemButton: BaseButton {
    private(set) var todo: TodoInfo
    
    init(todo: TodoInfo) {
        self.todo = todo
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let todoImageView = UIImageView()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let buttonLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.body2S
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override func configureView() {
        updateUI()
        
        backgroundColor = .grey700
        layer.cornerRadius = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [todoImageView, contentLabel, buttonLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        if todo.status != TodoStatus.waitCertification.rawValue {
            let imageSize = todo.status == TodoStatus.waitExamination.rawValue ? 22 : todo.status == TodoStatus.reject.rawValue ? 26 : 28 // MARK: 임의로 사이즈 조정
            todoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(imageSize)
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(
                todo.status == TodoStatus.waitCertification.rawValue ? self : todoImageView.snp.right
            ).offset(
                todo.status == TodoStatus.waitCertification.rawValue ? 16 : 8
            )
        }
        
        buttonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(72)
            $0.height.equalTo(28)
        }
    }
}

extension TodoListItemButton {
    private func updateUI() {
        guard let status = TodoStatus(rawValue: todo.status) else { return }
        
        todoImageView.image = status.image
        
        if status == .waitCertification {
            contentLabel.text = todo.content
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: status.contentColor
            ]
            contentLabel.attributedText = NSAttributedString(string: todo.content, attributes: attributes)
        }
        
        contentLabel.textColor = status.contentColor
        buttonLabel.text = status.buttonText
        buttonLabel.textColor = status.buttonTextColor
        buttonLabel.backgroundColor = status.buttonColor
    }
    
    func updateTodoStatus(_ status: TodoStatus) {
        self.todo.status = status.rawValue
        
        updateUI()
    }
}
