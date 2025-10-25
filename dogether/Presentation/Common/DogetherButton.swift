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
    
    private(set) var title: String
    private(set) var status: ButtonStatus
    
    private(set) var currentTodo: TodoEntity?
    
    init(title: String, status: ButtonStatus = .enabled) {
        self.title = title
        self.status = status
        
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
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            if currentTodo != datas.todos[datas.index] {
                currentTodo = datas.todos[datas.index]
                
                isHidden = datas.todos[datas.index].status != TodoStatus.waitCertification.rawValue
            }
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
