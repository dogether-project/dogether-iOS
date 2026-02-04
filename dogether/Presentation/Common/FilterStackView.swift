//
//  FilterStackView.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class FilterStackView: BaseStackView {
    var mainDelegate: MainDelegate? {
        didSet {
            [allChip, waitChip, approveChip, rejectChip].forEach { $0.mainDelegate = mainDelegate }
        }
    }

    var certificationListDelegate: CertificationListPageDelegate? {
        didSet {
            [allChip, waitChip, approveChip, rejectChip].forEach { $0.certificationListDelegate = certificationListDelegate }
        }
    }

    private let allChip = StatusChip(filterType: .all)
    private let waitChip = StatusChip(filterType: .status(.pending))
    private let rejectChip = StatusChip(filterType: .status(.reject))
    private let approveChip = StatusChip(filterType: .status(.approve))

    override func configureView() {
        axis = .horizontal
        spacing = 8
    }

    override func configureAction() { }

    override func configureHierarchy() {
        [allChip, waitChip, approveChip, rejectChip].forEach { addArrangedSubview($0) }
    }

    override func configureConstraints() { }

    // MARK: - updateView
    override func updateView(_ data: any BaseEntity) {
        if let datas = data as? FilterTypes {
            [allChip, waitChip, rejectChip, approveChip].forEach { $0.updateView(datas) }
        }
    }
}
