//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

final class StartViewController: BaseViewController {
    private let dogetherHeader = DogetherHeader()
    private let titleLabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "소속된 그룹이 없어요.\n그룹을 만들거나 참여하세요!",
            attributes: Fonts.getAttributes(for: Fonts.head1B)
        )
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    // TODO: 추후 descriptionButton 추가
    private func startButton(groupType: GroupTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        return button
    }
    private var createButton = UIButton()
    private var joinButton = UIButton()
    private func startImageView(groupType: GroupTypes) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = groupType.image
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    private var createImageView = UIImageView()
    private var joinImageView = UIImageView()
    private func startTitleLabel(groupType: GroupTypes) -> UILabel {
        let label = UILabel()
        label.text = groupType.startTitleText
        label.textColor = .grey0
        label.font = Fonts.head2B
        label.isUserInteractionEnabled = false
        return label
    }
    private var createTitleLabel = UILabel()
    private var joinTitleLabel = UILabel()
    private func startSubTitleLabel(groupType: GroupTypes) -> UILabel {
        let label = UILabel()
        label.text = groupType.startSubTitleText
        label.textColor = .grey400
        label.font = Fonts.body2R
        label.isUserInteractionEnabled = false
        return label
    }
    private var createSubTitleLabel = UILabel()
    private var joinSubTitleLabel = UILabel()
    private func startSChevronImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey300
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    private var createChevronImageView = UIImageView()
    private var joinChevronImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        createButton = startButton(groupType: .create)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        joinButton = startButton(groupType: .join)
        joinButton.addTarget(self, action: #selector(didTapJoinButton), for: .touchUpInside)
        createImageView = startImageView(groupType: .create)
        joinImageView = startImageView(groupType: .join)
        createTitleLabel = startTitleLabel(groupType: .create)
        joinTitleLabel = startTitleLabel(groupType: .join)
        createSubTitleLabel = startSubTitleLabel(groupType: .create)
        joinSubTitleLabel = startSubTitleLabel(groupType: .join)
        createChevronImageView = startSChevronImageView()
        joinChevronImageView = startSChevronImageView()
    }
    
    override func configureHierarchy() {
        [dogetherHeader, titleLabel, createButton, joinButton].forEach { view.addSubview($0) }
        [createImageView, createTitleLabel, createSubTitleLabel, createChevronImageView].forEach { createButton.addSubview($0) }
        [joinImageView, joinTitleLabel, joinSubTitleLabel, joinChevronImageView].forEach { joinButton.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        createButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        createImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        createTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(createImageView.snp.right).offset(8)
            $0.height.equalTo(28)
        }
        
        createSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(createTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(createImageView)
            $0.height.equalTo(21)
        }
        
        createChevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-21)
            $0.width.height.equalTo(28)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        joinImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        joinTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(joinImageView.snp.right).offset(8)
            $0.height.equalTo(28)
        }
        
        joinSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(joinTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(joinImageView)
            $0.height.equalTo(21)
        }
        
        joinChevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-21)
            $0.width.height.equalTo(28)
        }
    }
    
    @objc private func didTapCreateButton() {
        // TODO: 그룹 만들기 화면으로 넘어가도록 구현
    }
    
    @objc private func didTapJoinButton() {
        // TODO: 그룹 가입 화면으로 넘어가도록 구현
    }
}

