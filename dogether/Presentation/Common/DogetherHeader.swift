//
//  DogetherHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

final class DogetherHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherIcon = {
        let imageView = UIImageView()
        imageView.image = .logo
        return imageView
    }()
    
    private let dogetherIconTypo = {
        let imageView = UIImageView()
        imageView.image = .logoTypo
        return imageView
    }()
    
    // TODO: 추후 UIButton으로 수정
    private let chartIcon = {
        let imageView = UIImageView()
        imageView.image = .barChart
        return imageView
    }()
    
    private let profileIcon = {
        let imageView = UIImageView()
        imageView.image = .profile
        return imageView
    }()
    
    private func setUI() {
        [dogetherIcon, dogetherIconTypo, chartIcon, profileIcon].forEach { addSubview($0) }
        
        dogetherIcon.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        dogetherIconTypo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(dogetherIcon.snp.right).offset(7)
            $0.width.equalTo(80)
            $0.height.equalTo(18)
        }
        
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        chartIcon.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalTo(profileIcon.snp.left).offset(-24)
            $0.width.height.equalTo(24)
        }
    }
}
