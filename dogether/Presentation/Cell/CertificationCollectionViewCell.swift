//
//  CertificationCollectionViewCell.swift
//  dogether
//
//  Created by 박지은 on 2/16/25.
//

import UIKit
import SnapKit

class CertificationCollectionViewCell: BaseCollectionViewCell, ReusableProtocol {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    override func configureView() { }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
