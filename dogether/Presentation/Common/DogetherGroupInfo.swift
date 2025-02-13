//
//  DogetherGroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation
import UIKit

final class DogetherGroupInfo: UIView {
    var groupName: String
    var memberCount: Int
    var duration: GroupChallengeDurations
    var startAt: GroupStartAts
    let bgColor: UIColor
    
    init(
        groupName: String = "",
        memberCount: Int = 0,
        duration: GroupChallengeDurations = .threeDays,
        startAt: GroupStartAts = .today,
        backgroundColor: UIColor = .grey50
    ) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.duration = duration
        self.startAt = startAt
        self.bgColor = backgroundColor
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var groupInfoView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.grey100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var groupNameLabel = {
        let label = UILabel()
        label.textColor = .grey900
        label.font = Fonts.head1B
        return label
    }()
    
    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .grey100
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
        label.textColor = .grey800
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
    
    private func setUI() {
        groupInfoView.backgroundColor = bgColor
        
        durationDescriptionLabel = descriptionLabel()
        memberCountDescriptionLabel = descriptionLabel()
        startDayDescriptionLabel = descriptionLabel()
        endDayDescriptionLabel = descriptionLabel()
        
        durationInfoLabel = infoLabel()
        memberCountInfoLabel = infoLabel()
        startDayInfoLabel = infoLabel()
        endDayInfoLabel = infoLabel()
        
        groupNameLabel.text = groupName
        
        durationDescriptionLabel.text = "총 회차"
        memberCountDescriptionLabel.text = "그룹원"
        startDayDescriptionLabel.text = "시작일"
        endDayDescriptionLabel.text = "종료일"
        
        durationInfoLabel.text = "\(duration.rawValue)일"
        memberCountInfoLabel.text = "총 \(memberCount)명"
        startDayInfoLabel.text = "\(DateFormatterManager.formattedDate(startAt.daysFromToday)) (\(startAt.text))"
        endDayInfoLabel.text = "\(DateFormatterManager.formattedDate(startAt.daysFromToday + duration.rawValue)) (D-\(duration.rawValue))"
        
        [
            groupInfoView,
            durationDescriptionLabel, memberCountDescriptionLabel, startDayDescriptionLabel, endDayDescriptionLabel,
            durationInfoLabel, memberCountInfoLabel, startDayInfoLabel, endDayInfoLabel
        ].forEach { addSubview($0) }
        [groupNameLabel, dividerView].forEach { groupInfoView.addSubview($0) }
        
        groupInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(23)
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
    
    func setInfo(groupName: String, memberCount: Int, duration: GroupChallengeDurations, startAt: GroupStartAts) {
        self.groupName = groupName
        self.memberCount = memberCount
        self.duration = duration
        self.startAt = startAt
        
        groupNameLabel.text = groupName
        durationInfoLabel.text = "\(duration.rawValue)일"
        memberCountInfoLabel.text = "총 \(memberCount)명"
        startDayInfoLabel.text = "\(DateFormatterManager.formattedDate(startAt.daysFromToday)) (\(startAt.text))"
        endDayInfoLabel.text = "\(DateFormatterManager.formattedDate(startAt.daysFromToday + duration.rawValue)) (D-\(duration.rawValue))"
    }
}
