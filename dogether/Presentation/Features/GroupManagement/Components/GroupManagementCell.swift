//
//  GroupManagementCell.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import UIKit
import SnapKit

final class GroupManagementCell: BaseTableViewCell, ReusableProtocol {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body1R
        label.textColor = .grey100
        return label
    }()
    
    private let leaveButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.titleLabel?.font = Fonts.body2S
        button.setTitleColor(.grey200, for: .normal)
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 6
        return button
    }()
    
    var onLeaveButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func configureAction() {
        leaveButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                onLeaveButtonTapped?()
            },
            for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(leaveButton)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        
        leaveButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.width.equalTo(72)
            $0.height.equalTo(28)
        }
    }
    
    func configure(with group: GroupInfo) {
        titleLabel.text = group.name
    }
}
