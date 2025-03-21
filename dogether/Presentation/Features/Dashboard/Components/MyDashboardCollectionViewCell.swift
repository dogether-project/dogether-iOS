//
//  MyDashboardCollectionViewCell.swift
//  dogether
//
//  Created by 박지은 on 2/14/25.
//

import UIKit
import SnapKit

class MyDashboardCollectionViewCell: BaseCollectionViewCell, ReusableProtocol {
    
    private let icon = {
        let icon = UIImageView()
        return icon
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = Fonts.body2S
        label.textColor = .grey200
        label.textAlignment = .center
        return label
    }()
    
    private let countLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .grey0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configureHierarchy() {
        [icon, titleLabel, countLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17.5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configureView() { }
    
    func configure(with image: UIImage, title: String, count: String) {
        icon.image = image
        titleLabel.text = title
        countLabel.text = count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
