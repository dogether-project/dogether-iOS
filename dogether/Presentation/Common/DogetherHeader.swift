//
//  DogetherHeader.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class DogetherHeader: BaseView {
    weak var delegate: CoordinatorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    override func configureView() { }
    
    override func configureAction() {
        myPageButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.coordinator?.pushViewController(MyPageViewController())
            }, for: .touchUpInside
        )
    }
     
    override func configureHierarchy() {
        [dogetherIconTypo, myPageButton].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
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
}
