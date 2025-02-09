//
//  NavigationHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

class NavigationHeader: UIView {
    private var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUI()
    }
    
    // TODO: 추후 UIButton으로 수정
    private let prevIcon = {
        let imageView = UIImageView()
        imageView.image = .arrowLeft
        return imageView
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = title
        label.textColor = .grey900
        label.font = Fonts.bold(size: 18)
        return label
    }()
    
    private func setUI() {
        [prevIcon, titleLabel].forEach { addSubview($0) }
        
        prevIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
