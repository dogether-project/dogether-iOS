//
//  CertificationListViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

final class CertificationListViewController: BaseViewController {
    private let certificationListPage = CertificationListPage()
    private let viewModel = CertificationListViewModel()
    
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
        bind(viewModel.bottomSheetViewDatas)
        bind(viewModel.sortViewDatas)
        bind(viewModel.statsViewDatas)
        bind(viewModel.certificationListViewDatas)
    }
}

extension CertificationListViewController {
    // MARK: () -> Void 타입이어야 updateViewController지정 가능
    private func loadCertificationListView() {
        loadCertificationListView(page: 0)
    }
    
    private func loadCertificationListView(page: Int) {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadCertificationList(page: page)
        }
    }
}

protocol CertificationListPageDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectSortAction(index: Int)
    func selectFilterAction(filterType: FilterTypes)
    func selectCertificationAction(title: String, todos: [TodoEntity], index: Int)
    func didScrollToBottom()
}

extension CertificationListViewController: CertificationListPageDelegate {
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectSortAction(index: Int) {
        viewModel.updateSortIndex(index: index)
        
        loadCertificationListView()
    }
    
    func selectFilterAction(filterType: FilterTypes) {
        viewModel.updateFilter(filter: filterType)
    }
    
    func selectCertificationAction(title: String, todos: [TodoEntity], index: Int) {
        let certificationViewController = CertificationViewController()
        let certificationViewDatas = CertificationViewDatas(title: title, todos: todos, index: index)
        coordinator?.pushViewController(certificationViewController, datas: certificationViewDatas)
    }
    
    func didScrollToBottom() {
        loadCertificationListView(page: viewModel.certificationListViewDatas.value.currentPage + 1)
    }
}
