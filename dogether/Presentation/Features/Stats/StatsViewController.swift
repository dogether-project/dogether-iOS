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
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.statsPageViewDatas)
        bind(viewModel.groupViewDatas)
        bind(viewModel.achievementViewDatas)
        bind(viewModel.myRankViewDatas)
        bind(viewModel.summaryViewDatas)
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
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMain()
                    self.showError(error)
                }
            }
        }
    }
    
    private func reloadStats(index: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.fetchStatsForSelectedGroup()
                await MainActor.run {
                    self.showMain()
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
//        errorView?.removeFromSuperview()
//        errorView = ErrorHandlingManager.embedErrorView(
//            in: self,
//            under: statsPage.navigationHeader,
//            error: error,
//            retryHandler: { [weak self] in
//                self?.loadStatsView()
//            }
//        )
    }
    
    private func showMain() {
//        pages?.forEach { $0.isHidden = false }
//        errorView = nil
    }
    
    private func hideMain() {
//        pages?.forEach { $0.isHidden = true }
    }
}

protocol StatsDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectGroupAction(index: Int)
}

extension StatsViewController: StatsDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectGroupAction(index: Int) {
        viewModel.groupViewDatas.update { $0.index = index }
        viewModel.saveLastSelectedGroupIndex(index: index)
        
        reloadStats(index: index)
    }
}
