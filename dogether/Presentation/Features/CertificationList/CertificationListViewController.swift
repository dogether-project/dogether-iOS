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
    private let certificationListContentView = CertificationListContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayViewForCurrentStatus()
    }
    
    override func configureView() {
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
    }
    
    override func configureHierarchy() {
        [navigationHeader, certificationListEmptyView, certificationListContentView].forEach { view.addSubview($0) }
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
        
        certificationListContentView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension CertificationListViewController {
    private func displayViewForCurrentStatus() {
        certificationListEmptyView.isHidden = viewModel.certificationListViewStatus != .empty
        certificationListContentView.isHidden = viewModel.certificationListViewStatus != .hasData
    }
}

