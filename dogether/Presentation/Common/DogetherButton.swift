//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

final class DogetherButton: BaseButton {
    private let title: String
    
    init(_ title: String) {
        self.title = title
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private(set) var currentViewDatas: DogetherButtonViewDatas?
    
    override func configureView() {
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.body1B
        layer.cornerRadius = 8
        
        setTitleColor(ButtonStatus.enabled.textColor, for: .normal)
        backgroundColor = ButtonStatus.enabled.backgroundColor
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
        guard let datas = data as? DogetherButtonViewDatas else { return }
        
        if currentViewDatas != datas {
            currentViewDatas = datas
            
            setTitleColor(datas.status.textColor, for: .normal)
            backgroundColor = datas.status.backgroundColor
            isEnabled = datas.status == .enabled
        }
    }
}

// MARK: - ViewDatas
struct DogetherButtonViewDatas: BaseEntity {
    var status: ButtonStatus
    
    init(status: ButtonStatus = .enabled) {
        self.status = status
    }
}
