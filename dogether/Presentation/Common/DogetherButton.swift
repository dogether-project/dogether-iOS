//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit

final class DogetherButton: UIButton {
    var action: () -> Void
    var title: String
    var buttonColor: UIColor
    var disabled: Bool
    
    init(action: @escaping () -> Void, title: String, buttonColor: UIColor = .blue300, disabled: Bool = false) {
        self.action = action
        self.title = title
        self.buttonColor = buttonColor
        self.disabled = disabled
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var dogetherButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        button.layer.cornerRadius = 12
        return button
    }()
    
    private func setUI() {
        dogetherButton.setTitle(title, for: .normal)
        dogetherButton.backgroundColor = buttonColor
        dogetherButton.addTarget(self, action: #selector(didTapDogetherButton), for: .touchUpInside)
        
        [dogetherButton].forEach { addSubview($0) }
        
        dogetherButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    func setButtonDisabled(_ disabled: Bool) {
        self.disabled = disabled
    }
    
    @objc func didTapDogetherButton() {
        if !disabled {
            action()
        }
    }
}
