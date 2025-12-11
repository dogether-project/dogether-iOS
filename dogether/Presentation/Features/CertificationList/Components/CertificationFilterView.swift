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
            
            [allButton, waitButton, approveButton, rejectButton].forEach { button in
                button.addTapAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.certificationListPageDidChangeFilter(button.type)
                }
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    let sortButton = CertificationSortButton()
    
    private var allButton = FilterButton(type: .all)
    private var waitButton = FilterButton(type: .wait)
    private var rejectButton = FilterButton(type: .reject)
    private var approveButton = FilterButton(type: .approve)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func configureView() {
        setupScrollView()
        setupContentStackView()
        setupButtons()
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalToSuperview()
        }
    }
    
    override func updateView(_ data: any BaseEntity) {
        guard let datas = data as? CertificationListViewDatas else { return }
        sortButton.updateSelectedOption(datas.selectedSortOption)
        applyFilter(datas.currentFilter)
    }
}

extension CertificationFilterView {
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
    }
    
    private func setupButtons() {
        contentStackView.addArrangedSubview(sortButton)
        [allButton, waitButton, approveButton, rejectButton].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    func applyFilter(_ filter: FilterTypes) {
        allButton.setIsColorful(filter == .all)
        waitButton.setIsColorful(filter == .wait)
        rejectButton.setIsColorful(filter == .reject)
        approveButton.setIsColorful(filter == .approve)
    }
}
