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
    
    private var prevButton = {
        let button = UIButton()
        button.setImage(.arrowLeft, for: .normal)
        return button
    }()
    
    private var titleLabel = {
        let label = UILabel()
        label.textColor = .grey900
        label.font = Fonts.bold(size: 18)
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
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
    
    @objc func didTapPrevButton() {
        // TODO: 추후 이전 페이지로 이동하도록 구현
    }
}
