//
//  StepInfoView.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import UIKit

final class StepInfoView: BaseView {
    private let currentStepLabel = UILabel()
    private let maxStepLabel = UILabel()
    private let stepLabelStackView = UIStackView()
    private let stepDescriptionLabel = UILabel()
    
    override func configureView() {
        currentStepLabel.textColor = .blue300
        currentStepLabel.font = Fonts.body1S
        
        maxStepLabel.text = "/\(CreateGroupSteps.allCases.count)"
        maxStepLabel.textColor = .grey0
        maxStepLabel.font = Fonts.body1S
        
        stepLabelStackView.axis = .horizontal
        
        stepDescriptionLabel.textColor = .grey0
        stepDescriptionLabel.font = Fonts.head1B
        
        [currentStepLabel, maxStepLabel].forEach { stepLabelStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [stepLabelStackView, stepDescriptionLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        stepLabelStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(25)
        }

        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabelStackView.snp.bottom).offset(8)
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            currentStepLabel.text = "\(datas.step.rawValue)"
            stepDescriptionLabel.text = datas.step.description
        }
    }
}
