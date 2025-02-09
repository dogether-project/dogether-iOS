//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit

class DogetherButton: UIButton {
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
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = Fonts.bold(size: 16)
        self.addTarget(self, action: #selector(didTapDogetherButton), for: .touchUpInside)
        
        self.backgroundColor = buttonColor
        self.layer.cornerRadius = 12
    }
    
    func toggleButtonDisabled() {
        self.disabled.toggle()
    }
    func setButtonDisabled(_ disabled: Bool) {
        self.disabled = disabled
    }
    
    @objc func didTapDogetherButton() {
        if !disabled {
            action()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
