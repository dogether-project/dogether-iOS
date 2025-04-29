//
//  CertificationSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationSummaryView: BaseView {
    private let viewModel: CertificationListViewModel
    private let stackView = UIStackView()
    private lazy var achievedView = SummaryStatView(icon: UIImage(named: "certification")!,
                                                    title: "달성",
                                                    count: viewModel.certificationSummary.achievedCount)
    private lazy var certifiedView = SummaryStatView(icon: UIImage(named: "approve")!,
                                                     title: "인정",
                                                     count: viewModel.certificationSummary.certifiedCount)
    private lazy var notCertifiedView = SummaryStatView(icon: UIImage(named: "reject")!,
                                                        title: "노인정",
                                                        count: viewModel.certificationSummary.rejectedCount)
    
    init(viewModel: CertificationListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
    }
    
    override func configureAction() {
    }

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
