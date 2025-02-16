//
//  NavigationHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

final class NavigationHeader: UIView {
    private var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let prevButton = {
        let button = UIButton()
        button.setImage(.arrowLeft.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private func setUI() {
        prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        titleLabel.text = title
        
        [prevButton, titleLabel].forEach { addSubview($0) }
        
        prevButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
    
    @objc private func didTapPrevButton() {
        NavigationManager.shared.popViewController()
    }
}
