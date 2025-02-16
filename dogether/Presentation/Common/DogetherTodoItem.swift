//
//  DogetherTodoItem.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation
import UIKit
import SnapKit

final class DogetherTodoItem: UIButton {
    var action: () async -> Void    // TODO: 추후 개선
    private(set) var todo: TodoInfo
    
    init(action: @escaping () -> Void, todo: TodoInfo) {
        self.action = action
        self.todo = todo
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherTodoItem = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        return button
    }()
    
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
    private func setUI() {
        dogetherTodoItem.addTarget(self, action: #selector(didTapTodoItem), for: .touchUpInside)
        updateUI()
        
        [dogetherTodoItem].forEach { addSubview($0) }
        [todoImageView, contentLabel, buttonLabel].forEach { dogetherTodoItem.addSubview($0) }
        
        dogetherTodoItem.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        if todo.status != .waitCertificattion {
            todoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(todo.status == .waitExamination ? 22 : todo.status == .reject ? 26 : 28)    // MARK: 임의로 사이즈 조정
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(
                todo.status == .waitCertificattion ? dogetherTodoItem : todoImageView.snp.right
            ).offset(
                todo.status == .waitCertificattion ? 16 : 8
            )
        }
        
        buttonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(72)
            $0.height.equalTo(28)
        }
    }
    
    func updateTodoStatus(_ status: TodoStatus) {
        self.todo.status = status
        updateUI()
    }
    
    private func updateUI() {
        todoImageView.image = todo.status.image
        if todo.status == .waitCertificattion {
            contentLabel.text = todo.content
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: todo.status.contentColor
            ]
            contentLabel.attributedText = NSAttributedString(string: todo.content, attributes: attributes)
        }
        contentLabel.textColor = todo.status.contentColor
        buttonLabel.text = todo.status.buttonText
        buttonLabel.textColor = todo.status.buttonTextColor
        buttonLabel.backgroundColor = todo.status.buttonColor
    }
    
    @objc private func didTapTodoItem() {
        Task { @MainActor in
            await action()
        }
    }
}
