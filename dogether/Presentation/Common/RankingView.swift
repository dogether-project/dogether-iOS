//
//  RankingView.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation
import UIKit
import SnapKit

final class RankingView: UIView {
    private let ranking: RankingModel
    init(ranking: RankingModel) {
        self.ranking = ranking
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let rankingView = UIView()
    private let rankingLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body2S
        return label
    }()
    private let profileImageView = UIImageView()
    private let nameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.body1S
        return label
    }()
    private let certificationImageView = {
        let imageView = UIImageView()
        imageView.image = .certification
        return imageView
    }()
    private let certificationLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body2S
        return label
    }()
    
    private func setUI() {
        rankingLabel.text = String(ranking.rank)
        profileImageView.image = .profile4
        nameLabel.text = ranking.name
        certificationLabel.text = "\(ranking.certificationRate)%"
        
        [rankingView, rankingLabel, profileImageView, nameLabel, certificationImageView, certificationLabel].forEach { addSubview($0) }
        
        rankingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(rankingLabel.snp.right).offset(20)
            $0.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        certificationImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(certificationLabel.snp.left).offset(-4)
            $0.width.height.equalTo(24)
        }
        
        certificationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(31)
        }
    }
}
