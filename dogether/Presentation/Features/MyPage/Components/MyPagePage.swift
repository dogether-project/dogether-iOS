//
//  MyPagePage.swift
//  dogether
//
//  Created by yujaehong on 11/8/25.
//

import UIKit

final class MyPagePage: BasePage {
    var delegate: MyPageDelegate? {
        didSet {
            statsButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goStatsViewAction()
                },
                for: .touchUpInside
            )
            
            myTodosListButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goMyTodoListAction()
                },
                for: .touchUpInside
            )
            
            groupManagementButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goGroupManagementAction()
                },
                for: .touchUpInside
            )
            
            settingButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.goSettingViewAction()
                },
                for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "마이페이지")
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let userProfileStackView = UIStackView()
    private let statsImageView = UIImageView()
    private let statsLabel = UILabel()
    private let statsButton = UIButton()
    private let statsContainerView = UIView()
    private let myTodosListButton = MyPageButton(icon: .timer, title: "인증목록")
    private let groupManagementButton = MyPageButton(icon: .group, title: "그룹관리")
    private let settingButton = MyPageButton(icon: .setting, title: "설정")
    private let mypageButtonStackView = UIStackView()
    
    
    private(set) var currentName: String?
    private(set) var currentImageUrl: String?
    
    override func configureView() {
        profileImageView.image = .profile
        profileImageView.contentMode = .scaleAspectFit
        
        nameLabel.textColor = .grey0
        nameLabel.font = Fonts.head2B
        
        userProfileStackView.axis = .horizontal
        userProfileStackView.spacing = 20
        
        statsImageView.image = .happyDosik
        statsImageView.contentMode = .scaleAspectFit
        
        statsLabel.text = "그룹별 진행 상황을 모아봤어요!"
        statsLabel.font = Fonts.body1S
        statsLabel.textColor = .grey0
        statsLabel.textAlignment = .center
        
        statsButton.setTitle("통계 보러가기", for: .normal)
        statsButton.setTitleColor(.grey900, for: .normal)
        statsButton.titleLabel?.font = Fonts.body1B
        statsButton.backgroundColor = .blue300
        statsButton.layer.cornerRadius = 12
        
        statsContainerView.backgroundColor = .clear
        statsContainerView.layer.cornerRadius = 12
        statsContainerView.layer.borderColor = UIColor.grey800.cgColor
        statsContainerView.layer.borderWidth = 1.5
        
        mypageButtonStackView.axis = .vertical
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [profileImageView, nameLabel].forEach { userProfileStackView.addArrangedSubview($0) }
        [statsImageView, statsLabel, statsButton].forEach { statsContainerView.addSubview($0) }
        [myTodosListButton, groupManagementButton, settingButton].forEach { mypageButtonStackView.addArrangedSubview($0) }
        
        [navigationHeader, userProfileStackView, statsContainerView, mypageButtonStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        userProfileStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        statsContainerView.snp.makeConstraints {
            $0.top.equalTo(userProfileStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(251)
        }
        
        statsImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(33)
            $0.width.equalTo(86)
            $0.height.equalTo(94)
        }
        
        statsLabel.snp.makeConstraints {
            $0.top.equalTo(statsImageView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        statsButton.snp.makeConstraints {
            $0.top.equalTo(statsLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        mypageButtonStackView.snp.makeConstraints {
            $0.top.equalTo(statsContainerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ProfileEntity {
            if currentName != datas.name {
                currentName = datas.name
                nameLabel.text = datas.name
            }
            
            if currentImageUrl != datas.imageUrl {
                currentImageUrl = datas.imageUrl
                profileImageView.loadImage(url: datas.imageUrl)
            }
        }
    }
}
