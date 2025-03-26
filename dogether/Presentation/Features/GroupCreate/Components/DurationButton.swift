//
//  DurationButton.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import UIKit

final class DurationButton: UIButton {
    private(set) var duration: GroupChallengeDurations
    private(set) var isColorful: Bool
    
    init(duration: GroupChallengeDurations, isColorful: Bool = false) {
        self.duration = duration
        self.isColorful = isColorful
        
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let label = UILabel()
    
    private func updateUI() {
        layer.borderColor = isColorful ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        
        label.textColor = isColorful ? .blue300 : .grey0
        label.font = isColorful ? Fonts.body1B : Fonts.body1S
    }
    
    private func setUI() {
        updateUI()
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        
        label.text = duration.text
        
        [label].forEach { addSubview($0) }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    func setColorful(isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
}
