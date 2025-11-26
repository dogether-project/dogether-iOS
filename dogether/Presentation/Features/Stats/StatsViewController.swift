//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class StatsViewController: BaseViewController {
    private let statsPage = StatsPage()
    private let viewModel = StatsViewModel()
    
    private var errorView: ErrorView?
    private var bottomSheetVC: BottomSheetViewController?

    override func viewDidLoad() {
        statsPage.delegate = self
        pages = [statsPage]
        
        super.viewDidLoad()
        
        coordinator?.updateViewController = loadStatsView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatsView()
    }

    override func setViewDatas() {
        bind(viewModel.statsPageViewDatas)
        bind(viewModel.groupInfoViewDatas)
        bind(viewModel.achievementBarViewDatas)
        bind(viewModel.myRankViewDatas)
        bind(viewModel.summaryViewDatas)
        bind(viewModel.groupSortViewDatas)
    }
}

extension StatsViewController {
    private func loadStatsView() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.loadStatsView()
                await MainActor.run {
                    self.showMain()
                    self.configureBottomSheet()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMain()
                    self.showError(error)
                }
            }
        }
    }
    
    private func reloadStats(_ selected: GroupSortOption) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.fetchStatsForSelectedGroup(selected)
                await MainActor.run {
                    self.showMain()
                    self.configureBottomSheet()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMain()
                    self.showError(error)
                }
            }
        }
    }
}

// MARK: - Error / Main Toggle
extension StatsViewController {
    private func showError(_ error: NetworkError) {
        errorView?.removeFromSuperview()
        errorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: statsPage.navigationHeader,
            error: error,
            retryHandler: { [weak self] in
                self?.loadStatsView()
            }
        )
    }
    
    private func showMain() {
        pages?.forEach { $0.isHidden = false }
        errorView = nil
    }
    
    private func hideMain() {
        pages?.forEach { $0.isHidden = true }
    }
}

extension StatsViewController {
    private func configureBottomSheet() {
        let sortDatas = viewModel.groupSortViewDatas.value
        
        let items = sortDatas.options.map { $0.bottomSheetItem }
        let selected = sortDatas.selected?.bottomSheetItem
        
        guard !items.isEmpty else {
            bottomSheetVC = nil
            return
        }
        
        bottomSheetVC = BottomSheetViewController(
            titleText: "그룹 선택",
            bottomSheetItem: items,
            selectedItem: selected
        )
        
        bottomSheetVC?.modalPresentationStyle = .overCurrentContext
        bottomSheetVC?.modalTransitionStyle = .coverVertical
        
        bottomSheetVC?.didSelectOption = { [weak self] item in
            guard let selected = item.value as? GroupSortOption else { return }
            self?.reloadStats(selected)
        }
    }
}

extension StatsViewController: BottomSheetDelegate {
    func presentBottomSheet() {
        if presentedViewController == nil,
           let bottomSheetVC {
            present(bottomSheetVC, animated: true)
        }
    }
}
