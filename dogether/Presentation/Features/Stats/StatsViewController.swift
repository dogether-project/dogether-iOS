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
    private var statsContentView: StatsContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchStats(groupId: 1)
    }

    override func configureAction() {
        navigationHeader.delegate = self
        viewModel.delegate = self
        
        statsEmptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinator?.pushViewController(GroupCreateViewController())
        }
    }

    override func configureHierarchy() {
        view.addSubview(navigationHeader)
        view.addSubview(statsEmptyView)
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
    }
}

extension StatsViewController {
    private func displayViewForCurrentStatus() {
        if viewModel.statsViewStatus == .hasData,
           statsContentView == nil {
            let contentView = StatsContentView(viewModel: viewModel)
            self.statsContentView = contentView
            view.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.top.equalTo(navigationHeader.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
            statsContentView?.isHidden = false
        }
    }
}

extension StatsViewController: StatsViewModelDelegate {
    func didFetchStatsSucceed() {
        DispatchQueue.main.async {
            self.displayViewForCurrentStatus()
        }
    }
}
