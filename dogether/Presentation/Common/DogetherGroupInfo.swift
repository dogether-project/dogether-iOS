//
//  DogetherGroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import UIKit

final class DogetherGroupInfo: BaseView {
    private var currentGroupName: String = ""
    private var currentMemberCount: Int = 0
    private var currentDuration: GroupChallengeDurations = .threeDays
    private var currentStartAtString: String = ""
    private var currentEndAtString: String = ""
    
    private let groupInfoView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let groupNameLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .grey600
        return view
    }()
    
    private func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.body1B
        return label
    }
    
    private func infoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grey200
        label.font = Fonts.body1R
        return label
    }
    
    private var durationDescriptionLabel = UILabel()
    private var memberCountDescriptionLabel = UILabel()
    private var startDayDescriptionLabel = UILabel()
    private var endDayDescriptionLabel = UILabel()
    
    private var durationInfoLabel = UILabel()
    private var memberCountInfoLabel = UILabel()
    private var startDayInfoLabel = UILabel()
    private var endDayInfoLabel = UILabel()
    
    override func configureView() {
        durationDescriptionLabel = descriptionLabel()
        memberCountDescriptionLabel = descriptionLabel()
        startDayDescriptionLabel = descriptionLabel()
        endDayDescriptionLabel = descriptionLabel()
        
        durationInfoLabel = infoLabel()
        memberCountInfoLabel = infoLabel()
        startDayInfoLabel = infoLabel()
        endDayInfoLabel = infoLabel()
        
        durationDescriptionLabel.text = "활동 기간"
        memberCountDescriptionLabel.text = "그룹원"
        startDayDescriptionLabel.text = "시작일"
        endDayDescriptionLabel.text = "종료일"
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [ groupInfoView,
          durationDescriptionLabel, memberCountDescriptionLabel, startDayDescriptionLabel, endDayDescriptionLabel,
          durationInfoLabel, memberCountInfoLabel, startDayInfoLabel, endDayInfoLabel
        ].forEach { addSubview($0) }
        
        [groupNameLabel, dividerView].forEach { groupInfoView.addSubview($0) }
    }
    
    override func configureConstraints() {
        groupInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(24)
            $0.height.equalTo(1)
        }
        
        durationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.left.equalTo(dividerView)
            $0.height.equalTo(25)
        }
        
        memberCountDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(durationDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(durationDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        startDayDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(memberCountDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        endDayDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(startDayDescriptionLabel.snp.bottom).offset(12)
            $0.left.equalTo(startDayDescriptionLabel)
            $0.height.equalTo(25)
        }
        
        durationInfoLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.right.equalTo(dividerView)
            $0.height.equalTo(25)
        }
        
        memberCountInfoLabel.snp.makeConstraints {
            $0.top.equalTo(durationInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(durationInfoLabel)
            $0.height.equalTo(25)
        }
        
        startDayInfoLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(memberCountInfoLabel)
            $0.height.equalTo(25)
        }
        
        endDayInfoLabel.snp.makeConstraints {
            $0.top.equalTo(startDayInfoLabel.snp.bottom).offset(12)
            $0.right.equalTo(startDayInfoLabel)
            $0.height.equalTo(25)
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        guard let data = data as? DogetherGroupInfoViewData else { return }

        currentGroupName = data.name
        currentMemberCount = data.memberCount
        currentDuration = GroupChallengeDurations(rawValue: data.duration) ?? .threeDays
        currentStartAtString = data.startDay
        currentEndAtString = data.endDay

        groupNameLabel.text = currentGroupName
        durationInfoLabel.text = currentDuration.text
        memberCountInfoLabel.text = "총 \(currentMemberCount)명"
        startDayInfoLabel.text = currentStartAtString
        endDayInfoLabel.text = currentEndAtString
    }
}
