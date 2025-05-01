//
//  StatsSummaryView.swift
//  dogether
//
//  Created by yujaehong on 4/30/25.
//

import UIKit
import SnapKit

final class StatsSummaryView: BaseView {
    var viewModel: StatsViewModel
    
    private let titleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chart3")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "요약"
        label.font = Fonts.body1S
        label.textColor = .grey0
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleIconImageView,
                                                   titleLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private lazy var achievedStackView = makeSummaryRow(imageName: "certification2",
                                                        title: "달성",
                                                        titleWidth: 25,
                                                        count: "123개")
    private lazy var acknowledgedStackView = makeSummaryRow(imageName: "approve",
                                                            title: "인정",
                                                            titleWidth: 25,
                                                            count: "123개")
    private lazy var notAcknowledgedStackView = makeSummaryRow(imageName: "reject",
                                                               title: "노인정",
                                                               titleWidth: 37,
                                                               count: "123개")
    
    private lazy var summaryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            achievedStackView,
            acknowledgedStackView,
            notAcknowledgedStackView
        ])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(titleStackView)
        addSubview(summaryStackView)
    }
    
    override func configureConstraints() {
        titleIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(25)
        }
        
        summaryStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(88)
        }
    }
}

extension StatsSummaryView {
    private func makeSummaryRow(imageName: String,
                                title: String,
                                titleWidth: CGFloat,
                                count: String) -> UIStackView {
        let icon = UIImageView()
        icon.image = UIImage(named: imageName)
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { $0.width.height.equalTo(24) }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Fonts.body2S
        titleLabel.textColor = .grey200
        titleLabel.snp.makeConstraints { $0.width.equalTo(titleWidth) }
        
        let countLabel = UILabel()
        countLabel.text = count
        countLabel.font = Fonts.body2S
        countLabel.textColor = .grey0
        
        let stack = UIStackView(arrangedSubviews: [icon, titleLabel, countLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.setCustomSpacing(8, after: titleLabel)
        stack.alignment = .center
        
        return stack
    }
}
