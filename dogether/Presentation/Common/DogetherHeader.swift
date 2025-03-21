//
//  DogetherHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class DogetherHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherIconTypo = {
        let imageView = UIImageView()
        imageView.image = .logoTypo.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey0
        return imageView
    }()
    
    private let myPageButton = {
        let button = UIButton()
        button.setImage(.profile.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private func setUI() {
        myPageButton.addTarget(self, action: #selector(didTapMyPageButton), for: .touchUpInside)
        
        [dogetherIconTypo, myPageButton].forEach { addSubview($0) }
        
        dogetherIconTypo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(91)
            $0.height.equalTo(20)
        }
        
        myPageButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    @objc private func didTapMyPageButton() {
        NavigationManager.shared.pushViewController(MyPageViewController())
    }
}
