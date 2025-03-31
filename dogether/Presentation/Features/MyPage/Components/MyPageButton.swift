//
//  MyPageButton.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

import UIKit

final class MyPageButton: UIButton {
    private let iconImageView = UIImageView()
    
    private let buttonTitleLabel = {
        let label = UILabel()
        label.textColor = .grey100
        label.font = Fonts.body1R
        return label
    }()
    
    private let chevronImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    
    init(icon: UIImage, title: String) {
        iconImageView.image = icon
        buttonTitleLabel.text = title
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUI() {
        chevronImageView.tintColor = .grey100
        
        [iconImageView, buttonTitleLabel, chevronImageView].forEach { addSubview($0) }
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImageView.snp.right).offset(8)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
    }
}
