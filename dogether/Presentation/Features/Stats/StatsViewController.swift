//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class StatsViewController: BaseViewController {
    var viewModel = StatsViewModel()
    
    private let navigationHeader = NavigationHeader(title: "통계")
    private let statsEmptyView = StatsEmptyView()
    private let statsContentView = StatsContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayViewForCurrentStatus()
    }
    
    override func configureView() {
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        statsEmptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinator?.pushViewController(GroupCreateViewController())
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(navigationHeader)
        view.addSubview(statsEmptyView)
        view.addSubview(statsContentView)
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        statsEmptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        statsContentView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension StatsViewController {
    private func displayViewForCurrentStatus() {
        statsEmptyView.isHidden = viewModel.statsViewStatus != .empty
        statsContentView.isHidden = viewModel.statsViewStatus != .hasData
    }
}
