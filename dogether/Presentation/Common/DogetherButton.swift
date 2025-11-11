//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

final class DogetherButton: BaseButton {
    var certificationDelegate: CertificationDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self, let currentTodo else { return }
                    certificationDelegate?.goCertificateViewAction(todo: currentTodo)
                }, for: .touchUpInside
            )
        }
    }
    var groupCreateDelegate: GroupCreateDelegate? {
        didSet {
            addAction(
                UIAction { [weak self] _ in
                    guard let self, let direction else { return }
                    groupCreateDelegate?.updateStep(direction: direction)
                }, for: .touchUpInside
            )
        }
    }
    
    private let direction: Directions?
    
    private(set) var title: String
    private(set) var status: ButtonStatus
    
    private(set) var currentTodo: TodoEntity?
    
    init(title: String, status: ButtonStatus = .enabled, direction: Directions? = nil) {
        self.title = title
        self.status = status
        self.direction = direction
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        updateUI()
        
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.body1B
        layer.cornerRadius = 8
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() { }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            if currentTodo != datas.todos[datas.index] {
                currentTodo = datas.todos[datas.index]
                
                isHidden = datas.rankingEntity != nil || datas.todos[datas.index].status != .waitCertification
            }
        }
        
        if let datas = data as? GroupCreateViewDatas {
            self.title = datas.step.buttonTitle
            
            // FIXME: 추후 수정
            setButtonStatus(status: datas.groupName.count > 0 ? .enabled : .disabled)
        }
    }
}

extension DogetherButton {
    private func updateUI() {
        setTitleColor(status.textColor, for: .normal)
        backgroundColor = status.backgroundColor
        isEnabled = status == .enabled
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setButtonStatus(status: ButtonStatus) {
        self.status = status
        
        updateUI()
    }
}
