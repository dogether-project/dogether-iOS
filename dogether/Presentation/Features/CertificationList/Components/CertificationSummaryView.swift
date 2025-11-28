//
//  CertificationSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSummaryView: BaseView {
    private let stackView = UIStackView()
    private let achievedView = CertificationSummaryStatView(type: .achievement)
    private let certifiedView = CertificationSummaryStatView(type: .approve)
    private let notCertifiedView = CertificationSummaryStatView(type: .reject)

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
    }
    
    override func configureAction() { }

    override func configureHierarchy() {
        [achievedView, certifiedView, notCertifiedView].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
    }

    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CertificationSummaryView {
    func configure(totalCertificatedCount: Int,
                   totalApprovedCount: Int,
                   totalRejectedCount: Int) {
        // FIXME: 추후 Rx 도입 시 updateView로 수정
        achievedView.updateView("\(totalCertificatedCount)개")
        certifiedView.updateView("\(totalApprovedCount)개")
        notCertifiedView.updateView("\(totalRejectedCount)개")
    }
}
