//
//  MyPageButton.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

import UIKit

final class MyPageButton: BaseButton {
    init(icon: UIImage, title: String) {
        iconImageView.image = icon
        buttonTitleLabel.text = title
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let iconImageView = UIImageView()
    
    private let buttonTitleLabel = {
        let label = UILabel()
        label.textColor = .grey100
        label.font = Fonts.body1R
        return label
    }()
    
    private let chevronImageView = UIImageView(image: .chevronRight.withRenderingMode(.alwaysTemplate))
    
    override func configureView() {
        chevronImageView.tintColor = .grey100
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [iconImageView, buttonTitleLabel, chevronImageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
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
