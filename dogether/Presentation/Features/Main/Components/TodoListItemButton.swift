//
//  TodoListItemButton.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class TodoListItemButton: BaseButton {
    var delegate: MainDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    if isUncertified {
                        if isToday {
                            delegate?.goCertificateViewAction(todo: todo)
                        } else { return }
                    } else {
                        delegate?.goCertificationViewAction(index: index)
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    private(set) var index: Int
    private(set) var todo: TodoEntity
    private(set) var isToday: Bool
    private(set) var isUncertified: Bool
    
    init(index: Int, todo: TodoEntity, isToday: Bool) {
        self.index = index
        self.todo = todo
        self.isToday = isToday
        self.isUncertified = todo.status == .uncertified
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let todoImageView = UIImageView()
    
    private let contentLabel = UILabel()
    
    private let certificationLabel = UILabel()
    
    private let checkImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    
    override func configureView() {
        backgroundColor = Color.Background.surface
        layer.cornerRadius = 8
        
        todoImageView.image = todo.status.image
        
        contentLabel.text = todo.content
        contentLabel.textColor = isUncertified ? isToday ? Color.Text.default : Color.Text.disabled : Color.Text.secondary
        contentLabel.font = Fonts.body1S
        contentLabel.isUserInteractionEnabled = false
        
        certificationLabel.text = "인증하기"
        certificationLabel.textColor = isToday ? .grey900 : Color.Text.disabled // FIXME: 색상 추가 필요
        certificationLabel.textAlignment = .center
        certificationLabel.font = Fonts.body2S
        certificationLabel.layer.cornerRadius = 8
        certificationLabel.clipsToBounds = true
        certificationLabel.isUserInteractionEnabled = false
        certificationLabel.backgroundColor = isToday ? Color.Background.primary : Color.Background.disabled
        
        checkImageView.tintColor = Color.Icon.elavated
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        let rightView = isUncertified ? certificationLabel : checkImageView
        [todoImageView, contentLabel, rightView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        if todo.status != .uncertified {
            todoImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
                $0.width.height.equalTo(24)
            }
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(isUncertified ? self : todoImageView.snp.right).offset(isUncertified ? 16 : 8)
            $0.right.equalTo(isUncertified ? certificationLabel.snp.left : checkImageView.snp.left)
        }
        
        if isUncertified {
            certificationLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-16)
                $0.width.equalTo(72)
                $0.height.equalTo(28)
            }
        } else {
            checkImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(-16)
                $0.width.height.equalTo(24)
            }
        }
    }
}
