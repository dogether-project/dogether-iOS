//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class StatsViewController: BaseViewController {
    
    private let navigationHeader = NavigationHeader(title: "통계")
    
    private let emptyStateView = EmptyStateView(
        title: "소속된 그룹이 없어요",
        description: "새로운 그룹을 만들어 함께 시작해보세요!"
    )
    
    private let createGroupButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 12
        button.setTitle("그룹 만들기", for: .normal)
        button.setTitleColor(.grey800, for: .normal)
        button.titleLabel?.font = Fonts.body1B
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        createGroupButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(GroupCreateViewController())
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, emptyStateView, createGroupButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(160)
            $0.centerX.equalToSuperview()
        }
        
        createGroupButton.snp.makeConstraints {
            $0.top.equalTo(emptyStateView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(50)
        }
    }
}

extension StatsViewController {
    private func updateView() {
        
    }
}
