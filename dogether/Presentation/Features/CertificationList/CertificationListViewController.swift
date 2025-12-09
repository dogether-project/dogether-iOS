//
//  CertificationListViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class CertificationListViewController: BaseViewController {
    private let certificationListPage = CertificationListPage()
    private let viewModel = CertificationListViewModel()
    
    private var errorView: ErrorView?
    
    override func viewDidLoad() {
        certificationListPage.delegate = self
        pages = [certificationListPage]
        
        super.viewDidLoad()
        
        coordinator?.updateViewController = loadCertificationListView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCertificationListView()
    }
    
    override func setViewDatas() {
        bind(viewModel.certificationListViewDatas)
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.sortSheetDatas)
    }
}

extension CertificationListViewController {
    private func loadCertificationListView() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.executeSort(option: .todoCompletionDate)
                await MainActor.run {
                    self.showMainContentViews()
                    self.errorView?.removeFromSuperview()
                    self.errorView = nil
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMainContentViews()
                    self.showErrorView(error: error)
                }
            }
        }
    }
    
    private func showErrorView(error: NetworkError) {
        errorView?.removeFromSuperview()
        
        errorView = ErrorHandlingManager.embedErrorView(
            in: self,
            under: certificationListPage.navigationHeader,
            error: error,
            retryHandler: { [weak self] in
                guard let self else { return }
                self.loadCertificationListView()
            }
        )
    }
    
    private func showMainContentViews() {
        certificationListPage.isHidden = false
    }
    
    private func hideMainContentViews() {
        certificationListPage.isHidden = true
    }
}

protocol CertificationListPageDelegate: AnyObject {
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectSortOption(option: CertificationSortOption)
    func certificationListPageDidChangeFilter(_ filter: FilterTypes)
    func certificationListPageDidSelectCertification(title: String, todos: [TodoEntity], index: Int)
    func certificationListPageDidReachBottom()
    func didTapCertification(title: String, todos: [TodoEntity], index: Int)
    func didScrollToBottom()
}

extension CertificationListViewController: CertificationListPageDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectSortOption(option: CertificationSortOption) {
        Task {
            do {
                try await viewModel.executeSort(option: option)
            } catch {
                await MainActor.run { self.showErrorView(error: error as! NetworkError) }
            }
        }
    }
    
    func certificationListPageDidChangeFilter(_ filter: FilterTypes) {
        viewModel.changeFilter(filter)
    }
    
    func certificationListPageDidSelectCertification(title: String, todos: [TodoEntity], index: Int) {
        let certificationViewController = CertificationViewController()
        let certificationViewDatas = CertificationViewDatas(title: title, todos: todos, index: index)
        coordinator?.pushViewController(certificationViewController, datas: certificationViewDatas)
    }
    
    func certificationListPageDidReachBottom() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.loadNextPage()
            } catch let error as NetworkError {
                await MainActor.run {
                    self.showErrorView(error: error)
                }
            }
        }
    }
    
    func didTapCertification(title: String, todos: [TodoEntity], index: Int) {
        let vc = CertificationViewController()
        let datas = CertificationViewDatas(title: title, todos: todos, index: index)
        coordinator?.pushViewController(vc, datas: datas)
    }
    
    func didScrollToBottom() {
        Task {
            do {
                try await viewModel.loadNextPage()
            } catch let error as NetworkError {
                await MainActor.run {
                    self.showErrorView(error: error)
                }
            }
        }
    }
}
