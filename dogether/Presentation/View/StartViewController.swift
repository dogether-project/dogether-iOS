//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

class StartViewController: BaseViewController {
    private let dogetherHeader = DogetherHeader()
    private lazy var createGroupButton = {
        let view = UIButton()
        view.backgroundColor = .grey50
        view.layer.cornerRadius = 12
        return view
    }()
    private let plusImageBackgroundView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    private let plusImageView = {
        let imageView = UIImageView()
        imageView.image = .plus.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey400
        return imageView
    }()
    private let createGroupLabel = {
        let label = UILabel()
        label.text = "새 그룹 만들기"
        label.textColor = .grey500
        label.font = Fonts.bold(size: 18)
        return label
    }()
    private let joinGroupButton = DogetherButton(action: {
        // TODO: 그룹 가입하기 화면으로 넘어가도록 구현
    }, title: "그룹 가입하기", buttonColor: .grey900)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [dogetherHeader, createGroupButton, joinGroupButton].forEach { view.addSubview($0) }
        [plusImageBackgroundView, createGroupLabel].forEach { createGroupButton.addSubview($0) }
        [plusImageView].forEach { plusImageBackgroundView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        createGroupButton.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }
        
        plusImageBackgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(createGroupButton.snp.top).offset(37)
            $0.width.height.equalTo(32)
        }
        
        plusImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.edges.equalToSuperview().inset(6.4)
            $0.width.height.equalTo(19.2)
        }
        
        createGroupLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(createGroupButton.snp.bottom).offset(-37)
            $0.height.equalTo(28)
        }
        
        joinGroupButton.snp.makeConstraints {
            $0.top.equalTo(createGroupButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        createGroupButton.addTarget(self, action: #selector(didTapCreateGroupButton), for: .touchUpInside)
        
        plusImageBackgroundView.isUserInteractionEnabled = false
        plusImageView.isUserInteractionEnabled = false
        createGroupLabel.isUserInteractionEnabled = false
    }
    
    @objc func didTapCreateGroupButton() {
        // TODO: 그룹 만들기 화면으로 넘어가도록 구현
    }
}

