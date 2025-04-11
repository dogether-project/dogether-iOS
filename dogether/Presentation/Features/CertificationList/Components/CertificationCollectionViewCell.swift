//
//  CertificationCollectionViewCell.swift
//  dogether
//
//  Created by 박지은 on 2/16/25.
//

import UIKit
import SnapKit

class CertificationCollectionViewCell: BaseCollectionViewCell, ReusableProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dateHeaderLabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey0
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey400
        return label
    }()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [dateHeaderLabel, dateLabel, imageView].forEach { contentView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dateHeaderLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateHeaderLabel.snp.bottom)
            $0.leading.equalTo(dateHeaderLabel.snp.leading)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(dateHeaderLabel.snp.bottom).offset(8)
            $0.leading.equalTo(dateLabel.snp.leading)
        }
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
