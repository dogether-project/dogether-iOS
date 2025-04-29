//
//  SummaryStatView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class SummaryStatView: BaseView {
    private let icon: UIImage
    private let title: String
    private let count: Int
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2S
        label.textColor = .grey200
        label.textAlignment = .center
        label.text = title
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey0
        label.textAlignment = .center
        label.text = "\(count)개"
        return label
    }()
    
    init(icon: UIImage, title: String, count: Int) {
        self.icon = icon
        self.title = title
        self.count = count
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    override func configureAction() {
    }
    
    override func configureHierarchy() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
    }

    override func configureConstraints() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.width.height.equalTo(107)
        }
    }
}
