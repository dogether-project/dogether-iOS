//
//  CertificationFilterView.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import UIKit
import SnapKit

final class CertificationFilterView: BaseView {
    var delegate: CertificationListPageDelegate? {
        didSet {
            sortButton.addTapAction { [weak self] _ in
                guard let self else { return }
                delegate?.updateBottomSheetVisibleAction(isShowSheet: true)
            }
            
            filterStackView.certificationListDelegate = delegate
        }
    }
    
    private let scrollView = UIScrollView()
    let sortButton = CertificationSortButton()
    private let filterStackView = FilterStackView()
    
    override func configureView() {
        setupScrollView()
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(filterStackView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        filterStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? SortViewDatas {
            sortButton.updateView(datas.options[datas.index])
            filterStackView.updateView(datas.filter)
        }
    }
}

extension CertificationFilterView {
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
    }
}
