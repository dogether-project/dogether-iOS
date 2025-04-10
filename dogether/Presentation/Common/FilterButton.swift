//
//  FilterButton.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class FilterButton: BaseButton {
    let type: FilterTypes
    private(set) var isColorful: Bool
    
    init(type: FilterTypes, isColorful: Bool = true) {
        self.type = type
        self.isColorful = isColorful
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var icon = UIImageView()
    
    private var label = UILabel()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    override func configureView() {
        updateUI()
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        
        icon.image = type.image?.withRenderingMode(.alwaysTemplate)
        
        label.text = type.rawValue
        label.font = Fonts.body2S
        
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [stackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(type.width)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(type == .wait ? 18 : type == .reject ? 22 : 24)    // MARK: 임의로 사이즈 조정
        }
    }
}

extension FilterButton {
    private func updateUI() {
        backgroundColor = isColorful ? type.backgroundColor : .grey800
        layer.borderColor = isColorful ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        icon.tintColor = isColorful ? .grey900 : .grey400
        label.textColor = isColorful ? .grey900 : .grey400
    }
    
    func setIsColorful(_ isColorful: Bool) {
        self.isColorful = isColorful
        
        updateUI()
    }
}
