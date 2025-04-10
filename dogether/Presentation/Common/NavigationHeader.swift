//
//  NavigationHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class NavigationHeader: BaseView{
    weak var delegate: CoordinatorDelegate?
    
    private var title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
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
    
    override func configureView() {
        titleLabel.text = title
    }
    
    override func configureAction() {
        prevButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.coordinator?.popViewController()
            }, for: .touchUpInside
        )
    }
     
    override func configureHierarchy() {
        [prevButton, titleLabel].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
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
}
