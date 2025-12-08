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
    private var bottomSheetViewController: BottomSheetViewController?
    
    override func viewDidLoad() {
        certificationListPage.delegate = self
        pages = [certificationListPage]
        
        super.viewDidLoad()
        
        certificationListPage.setBottomSheetDelegate(self)
        
        coordinator?.updateViewController = loadCertificationListView
        
        configureBottomSheetViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCertificationListView()
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificationListViewDatas {
            viewModel.certificationListViewDatas.accept(datas)
        }
        
        bind(viewModel.certificationListViewDatas)
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

extension CertificationListViewController {
    private func configureBottomSheetViewController() {
        let items = CertificationSortOption.allCases.map { $0.bottomSheetItem }
        let selectedItem = viewModel.certificationListViewDatas.value.selectedSortOption.bottomSheetItem
        
        bottomSheetViewController = BottomSheetViewController(
            titleText: "정렬",
            bottomSheetItem: items,
            selectedItem: selectedItem
        )
        
        bottomSheetViewController?.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController?.modalTransitionStyle = .coverVertical
        
        bottomSheetViewController?.didSelectOption = { [weak self] selected in
            guard let self,
                  let sortOption = selected.value as? CertificationSortOption else { return }
            
            Task { [weak self] in
                guard let self else { return }
                do {
                    try await self.viewModel.executeSort(option: sortOption)
                } catch let error as NetworkError {
                    await MainActor.run {
                        self.showErrorView(error: error)
                    }
                }
            }
        }
    }
}

extension CertificationListViewController: CertificationListPageDelegate {
    
    func certificationListPageDidChangeFilter(_ filter: FilterTypes) {
        viewModel.changeFilter(filter)
    }
    
    func certificationListPageDidSelectCertification(
        title: String,
        todos: [TodoEntity],
        index: Int
    ) {
        let certificationViewController = CertificationViewController()
        let certificationViewDatas = CertificationViewDatas(
            title: title,
            todos: todos,
            index: index
        )
        coordinator?.pushViewController(
            certificationViewController,
            datas: certificationViewDatas
        )
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
}

extension CertificationListViewController: BottomSheetDelegate {
    func presentBottomSheet() {
        guard presentedViewController == nil,
              let bottomSheetViewController
        else { return }
        
        present(bottomSheetViewController, animated: true)
    }
}

protocol CertificationListPageDelegate: AnyObject {
    func certificationListPageDidChangeFilter(_ filter: FilterTypes)
    func certificationListPageDidSelectCertification(
        title: String,
        todos: [TodoEntity],
        index: Int
    )
    func certificationListPageDidReachBottom()
}
