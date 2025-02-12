//
//  CreateGroupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

class CreateGroupViewModel {
    private(set) var currentStep: CreateGroupSteps = .one
    private(set) var isDisabledCompleteButton: Bool = true
    private(set) var currentGroupName: String = ""
    private(set) var groupNameMaxLength: Int = 18
    private(set) var memberCount: Int = 10
    private(set) var todoLimit: Int = 5
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    func updateStep(step: CreateGroupSteps) async {
        currentStep = step
    }
    
    func completeAction() async {
        if currentStep.rawValue < CreateGroupSteps.four.rawValue {
            guard let nextStep = CreateGroupSteps(rawValue: currentStep.rawValue + 1) else { return }
            Task { @MainActor in
                await updateStep(step: nextStep)
            }
        } else {
            // TODO: 추후 그룹 생성 API 연동, 그룹 만들기 완료 화면으로 이동
        }
    }
    
    func updateGroupName(groupName: String?) async -> (String, String, Bool) {
        currentGroupName = groupName ?? ""
        isDisabledCompleteButton = !(currentStep == .one && currentGroupName.count > 0)
        return (currentGroupName, "\(currentGroupName.count)/\(groupNameMaxLength)", isDisabledCompleteButton)
    }
    func updateMemberCount(count: Int) {
        memberCount = count
    }
    func updateTodoLimit(count: Int) {
        todoLimit = count
    }
    func updateDuration(duration: GroupChallengeDurations) async {
        currentDuration = duration
    }
    func updateStartAt(startAt: GroupStartAts) async {
        currentStartAt = startAt
    }
}
