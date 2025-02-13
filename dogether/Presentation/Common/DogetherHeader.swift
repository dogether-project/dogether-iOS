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
    
    private var statButton = {
        let button = UIButton()
        button.setImage(.barChart, for: .normal)
        return button
    }()
    
    private var myPageButton = {
        let button = UIButton()
        button.setImage(.profile, for: .normal)
        return button
    }()
    
    private func setUI() {
        statButton.addTarget(self, action: #selector(didTapStatButton), for: .touchUpInside)
        myPageButton.addTarget(self, action: #selector(didTapMyPageButton), for: .touchUpInside)
        
        [dogetherIcon, dogetherIconTypo, statButton, myPageButton].forEach { addSubview($0) }
        
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
        
        myPageButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        statButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalTo(myPageButton.snp.left).offset(-24)
            $0.width.height.equalTo(24)
        }
    }
    
    @objc func didTapStatButton() {
        // TODO: 추후 내통계로 이동하도록 구현
    }
    
    @objc func didTapMyPageButton() {
        // TODO: 추후 마이페이지로 이동하도록 구현
    }
}
