//
//  GroupCreatePage.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import UIKit
import SnapKit

final class GroupCreatePage: BasePage {
    var delegate: GroupCreateDelegate? {
        didSet {
            
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "그룹 만들기")
    private let stepInfoView = StepInfoView()
    private let completeButton = DogetherButton(title: "다음", status: .disabled)
    
    private var stepOneView = StepOneView()
    private var stepTwoView = StepTwoView()
    private var stepThreeView = StepThreeView()
    
    override func configureView() { }
    
    override func configureAction() {
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        navigationHeader.delegate = coordinatorDelegate

        completeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
//                if viewModel.currentStep.rawValue == viewModel.maxStep {
//                    tryCreateGroup()
//                } else {
//                    guard let nextStep = CreateGroupSteps(rawValue: viewModel.currentStep.rawValue + 1) else { return }
//                    viewModel.updateStep(step: nextStep)
//                    updateStep()
//                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [ navigationHeader, stepInfoView, completeButton,
          stepOneView, stepTwoView, stepThreeView
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        stepInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(44)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepOneView.snp.makeConstraints {
            $0.top.equalTo(stepInfoView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepTwoView.snp.makeConstraints {
            $0.top.equalTo(stepInfoView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        stepThreeView.snp.makeConstraints {
            $0.top.equalTo(stepInfoView.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(36)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupCreateViewDatas {
            stepInfoView.updateView(datas)
            
            [stepOneView, stepTwoView, stepThreeView].forEach {
                guard let step = CreateGroupSteps(rawValue: $0.tag) else { return }
                $0.isHidden = datas.step != step
            }
            
            if datas.step == .two { endEditing(true) }
            if datas.step == .three {
//                completeButton.updateView(datas)
//                dogetherGroupInfo.updateView(datas)
                
//                let viewData = DogetherGroupInfoViewData(
//                    name: viewModel.currentGroupName,
//                    memberCount: viewModel.memberCount,
//                    duration: viewModel.currentDuration.rawValue,
//                    startDay: DateFormatterManager.formattedDate(viewModel.currentStartAt.daysFromToday),
//                    endDay: DateFormatterManager.formattedDate(viewModel.currentStartAt.daysFromToday + viewModel.currentDuration.rawValue)
//                )
//                dogetherGroupInfo.updateView(viewData)
            }
        }
    }
}
