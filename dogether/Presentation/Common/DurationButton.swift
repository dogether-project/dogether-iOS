//
//  DurationButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation
import UIKit

final class DurationButton: UIButton {
    private(set) var action: (GroupChallengeDurations) -> Void
    private(set) var duration: GroupChallengeDurations
    private(set) var isColorful: Bool
    
    init(action: @escaping (GroupChallengeDurations) -> Void, duration: GroupChallengeDurations, isColorful: Bool = false) {
        self.action = action
        self.duration = duration
        self.isColorful = isColorful
        
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let label = UILabel()
    
    private func updateUI() {
        self.layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        
        label.textColor = isColorful ? .blue300 : .grey0
        label.font = isColorful ? Fonts.body1B : Fonts.body1S
    }
    
    private func setUI() {
        updateUI()
        
        self.backgroundColor = .grey800
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.addTarget(self, action: #selector(didTapDurationButton), for: .touchUpInside)
        
        label.text = duration.text
        
        [label].forEach { addSubview($0) }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    func setAction(action: @escaping (GroupChallengeDurations) -> Void) {
        self.action = action
    }
    
    func setColorful(isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
    
    @objc private func didTapDurationButton() {
        action(duration)
    }
}
