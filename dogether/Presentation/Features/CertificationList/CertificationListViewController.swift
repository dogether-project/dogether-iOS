//
//  CertificationListViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class CertificationListViewController: BaseViewController {
    var viewModel = CertificationListViewModel()
    private let navigationHeader = NavigationHeader(title: "인증 목록")
    private let certificationListEmptyView = CertificationListEmptyView()
    private var certificationListContentView: CertificationListContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.executeSort(option: .todoCompletionDate)
    }
    
    override func configureView() {
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        viewModel.delegate = self
    }
    
    override func configureHierarchy() {
        [navigationHeader, certificationListEmptyView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        certificationListEmptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension CertificationListViewController {
    private func displayViewForCurrentStatus() {
        if viewModel.viewStatus == .hasData,
           certificationListContentView == nil {
            let contentView = CertificationListContentView(viewModel: viewModel)
            self.certificationListContentView = contentView
            self.certificationListContentView?.delegate = self
            view.addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.top.equalTo(navigationHeader.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
            certificationListContentView?.isHidden = false
            certificationListEmptyView.isHidden = true
        }
    }
}

// MARK: - ViewModel 로 부터 갱신된 데이터를 가져와서 ContentView 업데이트
extension CertificationListViewController: CertificationListViewModelDelegate {
    func didFetchSucceed() {
        displayViewForCurrentStatus()
        certificationListContentView?.reloadData()
    }
}

// MARK: - ContentView 에서 전달하는 이벤트를 받기 위한 Delegate
extension CertificationListViewController: CertificationListContentViewDelegate {
    func didTapFilter(selectedFilter: FilterTypes) {
        viewModel.currentFilter = selectedFilter
    }
    
    func didTapSort(option: SortOption) {
        viewModel.executeSort(option: option)
    }
    
    func didTapCertificationFilterView() {
    }
}
