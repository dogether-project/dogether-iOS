//
//  CompleteViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation
import UIKit
import SnapKit

final class CompleteViewController: BaseViewController {
    private let completeType: CompleteTypes
    
    private var titleLabel = {
        let label = UILabel()
        label.textColor = .grey900
        label.font = Fonts.emphasisB
        return label
    }()
    private var subTitleLabel = {
        let label = UILabel()
        label.textColor = .grey500
        label.font = Fonts.body1R
        return label
    }()
    private let completeButton = DogetherButton(action: {
        // TODO: 추후 투두 작성하기로 이동
    }, title: "투두 작성하기")
    private var groupInfoView = DogetherGroupInfo(backgroundColor: .white)
    private let checkImageBackgroundView = {
        let view = UIView()
        view.backgroundColor = .blue300
        view.layer.cornerRadius = 29
        return view
    }()
    private let checkImageView = {
        let imageView = UIImageView()
        imageView.image = .check.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    private let joinCodeView = {
        let view = UIView()
        view.backgroundColor = .grey0
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.grey100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private var joinCodeLabel: UIView = {
        let label = UILabel()
        label.textColor = .grey900
        label.font = Fonts.head1B
        return label
    }()
    private let joinCodeImageView: UIView = {
        let imageView = UIImageView()
        imageView.image = .copy
        return imageView
    }()

    // TODO: 추후 초대 코드 또는 그룹 정보를 포함하도록 수정
    override init(type: CompleteTypes) {
        self.completeType = type
        super.init()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue100
    }
    
    override func configureView() {
        titleLabel.text = completeType.titleText
        subTitleLabel.text = completeType.subTitleText
        
        // TODO: 추후 수정
        switch completeType {
        case .join:
            groupInfoView.setInfo(groupName: "groupName", memberCount: 0, duration: .threeDays, startAt: .today)
        case .create:
            let label = joinCodeLabel as? UILabel
            label?.text = "123456789"
        }
    }
    
    override func configureHierarchy() {
        [titleLabel, subTitleLabel, completeButton].forEach { view.addSubview($0) }
        switch completeType {
        case .join:
            [groupInfoView].forEach { view.addSubview($0) }
        case .create:
            [checkImageBackgroundView, checkImageView, joinCodeView, joinCodeLabel, joinCodeImageView].forEach { view.addSubview($0) }
        }
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            switch completeType {
            case .join:
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            case .create:
                $0.top.equalTo(checkImageBackgroundView.snp.bottom).offset(36)
            }
            $0.height.equalTo(45)
        }
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            switch completeType {
            case .join:
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            case .create:
                $0.top.equalTo(joinCodeView.snp.bottom).offset(20)
            }
            $0.height.equalTo(25)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        switch completeType {
        case .join:
            groupInfoView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(267)
            }
        case .create:
            checkImageBackgroundView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(112)
                $0.width.height.equalTo(58)
            }
            checkImageView.snp.makeConstraints {
                $0.center.equalTo(checkImageBackgroundView)
                $0.width.height.equalTo(34)
            }
            joinCodeView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(47)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(75)
            }
            joinCodeLabel.snp.makeConstraints {
                $0.centerX.equalTo(joinCodeView).offset(-17)
                $0.centerY.equalTo(joinCodeView)
            }
            joinCodeImageView.snp.makeConstraints {
                $0.centerY.equalTo(joinCodeView)
                $0.left.equalTo(joinCodeLabel.snp.right).offset(10)
                $0.width.height.equalTo(24)
            }
        }
    }
}
