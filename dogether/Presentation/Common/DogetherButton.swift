//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit

final class DogetherButton: UIButton {
    private(set) var action: () async -> Void
    private(set) var title: String
    private(set) var status: ButtonStatus
    
    init(
        action: @escaping () -> Void,
        title: String,
        status: ButtonStatus
    ) {
        self.action = action
        self.title = title
        self.status = status
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.body1B
        button.layer.cornerRadius = 12
        return button
    }()
    
    private func setUI() {
        dogetherButton.setTitle(title, for: .normal)
        dogetherButton.setTitleColor(status.textColor, for: .normal)
        dogetherButton.backgroundColor = status.backgroundColor
        dogetherButton.isEnabled = status == .enabled
        dogetherButton.addTarget(self, action: #selector(didTapDogetherButton), for: .touchUpInside)
        
        [dogetherButton].forEach { addSubview($0) }
        
        dogetherButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    func setTitle(_ title: String) {
        self.title = title
        dogetherButton.setTitle(self.title, for: .normal)
    }
    
    func setButtonStatus(status: ButtonStatus) {
        self.status = status
        dogetherButton.setTitleColor(status.textColor, for: .normal)
        dogetherButton.backgroundColor = status.backgroundColor
        dogetherButton.isEnabled = status == .enabled
    }
    
    @objc private func didTapDogetherButton() {
        Task { @MainActor in
            await action()
        }
    }
}
