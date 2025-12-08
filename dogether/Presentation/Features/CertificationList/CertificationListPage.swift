//
//  CertificationListPage.swift
//  dogether
//
//  Created by yujaehong on 12/8/25.
//

import UIKit

final class CertificationListPage: BasePage {
    weak var delegate: CertificationListPageDelegate?
    
    func setBottomSheetDelegate(_ delegate: BottomSheetDelegate) {
        contentView.setBottomSheetDelegate(delegate)
    }
    
    let navigationHeader = NavigationHeader(title: "인증 목록")
    
    private let emptyView = CertificationListEmptyView()
    private let contentView = CertificationListContentView()
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
        contentView.delegate = self
    }
    
    override func configureHierarchy() {
        [navigationHeader, emptyView, contentView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        guard let datas = data as? CertificationListViewDatas else { return }
        
        switch datas.viewStatus {
        case .empty:
            emptyView.isHidden = false
            contentView.isHidden = true
            
        case .hasData:
            emptyView.isHidden = true
            contentView.isHidden = false
            contentView.updateView(datas)
        }
        
        contentView.isLastPage = datas.isLastPage
    }
}

extension CertificationListPage: CertificationListContentViewDelegate {
    func didTapFilter(selectedFilter: FilterTypes) {
        delegate?.certificationListPageDidChangeFilter(selectedFilter)
    }
    
    func didTapCertification(title: String, todos: [TodoEntity], index: Int) {
        delegate?.certificationListPageDidSelectCertification(
            title: title,
            todos: todos,
            index: index
        )
    }
    
    func didScrollToBottom() {
        delegate?.certificationListPageDidReachBottom()
    }
}
