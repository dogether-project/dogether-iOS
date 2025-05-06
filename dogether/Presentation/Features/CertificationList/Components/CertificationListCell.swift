//
//  CertificationListCell.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationCell: UICollectionViewCell {
    static let reuseIdentifier = "CertificationCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let statusButton: FilterButton = {
        let button = FilterButton(type: .wait)
        button.isUserInteractionEnabled = false // 버튼처럼 보이지만 동작은 안 하게
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(statusButton)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
//            $0.height.equalTo(200) // 이미지 높이를 적당히 설정
        }
        
        statusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.leading.equalTo(contentLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with certificationItem: CertificationItem) {
        // 이미지 설정
//        if let imageUrl = certificationItem.certificationMediaUrl, let url = URL(string: imageUrl) {
//            // 이미지 URL을 로드하는 코드 추가 가능
//            imageView.kf.setImage(with: url) // 예시: Kingfisher를 사용해 이미지 로드
//        }
        
        imageView.image = UIImage(named: "sample")!
        
        // 상태 버튼 업데이트
        if let filterType = FilterTypes(status: certificationItem.status) {
            statusButton.update(type: filterType)
        }
        
        // 인증 내용 설정
        contentLabel.text = certificationItem.certificationContent
        
        // 날짜 표시 (ex. "2025.05.01")
        dateLabel.text = certificationItem.createdAt
    }
}
