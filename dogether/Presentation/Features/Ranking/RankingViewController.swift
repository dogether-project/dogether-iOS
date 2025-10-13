//
//  RankingViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

import RxSwift
import RxCocoa

final class RankingViewController: BaseViewController {
    private let rankingPage = RankingPage()
    private let viewModel = RankingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        rankingPage.delegate = self
        
        pages = [rankingPage]
        
        super.viewDidLoad()
        
        coordinator?.updateViewController = loadRankingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRankingView()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? RankingViewDatas else { return }
        viewModel.rankingViewDatas.accept(datas)
    }
    
    override func bindViewModel() {
        viewModel.rankingViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: RankingViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                rankingPage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
    }
}

extension RankingViewController {
    private func loadRankingView() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.loadRankingView()
                await MainActor.run {
                    self.showMainContentViews()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMainContentViews()
                    self.showErrorView(error: error)
                }
            }
        }
    }
}

// MARK: - ErrorView
extension RankingViewController {
    private func showErrorView(error: NetworkError) {
//        errorView?.removeFromSuperview()
//        errorView = ErrorHandlingManager.embedErrorView(
//            in: self,
//            under: navigationHeader,
//            error: error,
//            retryHandler: { [weak self] in
//                guard let self else { return }
//                loadRankingView()
//            }
//        )
    }
    
    private func showMainContentViews() {
//        [rankingTopStackView, descriptionView, rankingTableView].forEach {
//            $0.isHidden = false
//        }
//        errorView = nil
    }
    
    private func hideMainContentViews() {
//        [rankingTopStackView, descriptionView, rankingTableView].forEach {
//            $0.isHidden = true
//        }
    }
}

// MARK: - delegate
protocol RankingDelegate {
    func goCertificationViewAction(memberInfo: RankingEntity)
}

extension RankingViewController: RankingDelegate {
    func goCertificationViewAction(memberInfo: RankingEntity) {
        // FIXME: MemberCertificationView RxSwift 구조 도입 후 수정
        let memberCertificationViewController = MemberCertificationViewController()
        memberCertificationViewController.viewModel.groupId = viewModel.rankingViewDatas.value.groupId
        memberCertificationViewController.viewModel.memberInfo = memberInfo
        coordinator?.pushViewController(memberCertificationViewController)
    }
}
