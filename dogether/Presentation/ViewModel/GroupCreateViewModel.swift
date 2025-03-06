//
//  GroupCreateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

final class GroupCreateViewModel {
    private let groupCreateUseCase: GroupCreateUseCase
    
    let groupNameMaxLength: Int = 12
    
    private(set) var currentStep: CreateGroupSteps = .one
    private(set) var isDisabledCompleteButton: Bool = true
    private(set) var currentGroupName: String = ""
    private(set) var memberCount: Int = 10
    private(set) var todoLimit: Int = 5
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    init() {
        let groupCreateRepository = GroupCreateRepository()
        self.groupCreateUseCase = GroupCreateUseCase(repository: groupCreateRepository)
    }
    
    func updateStep(step: CreateGroupSteps) {
        currentStep = step
    }
    
    func completeAction(updateStepUI: @escaping () -> Void) {
        if currentStep == .four {
            let createGroupRequest = CreateGroupRequest(
                name: currentGroupName,
                maximumMemberCount: memberCount,
                startAt: currentStartAt,
                durationOption: currentDuration,
                maximumTodoCount: todoLimit
            )
            groupCreateUseCase.navigateToCompleteView(createGroupRequest: createGroupRequest)
        } else {
            guard let nextStep = CreateGroupSteps(rawValue: currentStep.rawValue + 1) else { return }
            updateStep(step: nextStep)
            updateStepUI()
        }
    }
    
    func updateGroupName(groupName: String?) async -> (String, ButtonStatus) {
        currentGroupName = groupName ?? ""
        return (currentGroupName, currentStep == .one && currentGroupName.count > 0 ? .enabled : .disabled)
    }
    
    func updateMemberCount(count: Int) {
        memberCount = count
    }
    
    func updateTodoLimit(count: Int) {
        todoLimit = count
    }
    
    func updateDuration(duration: GroupChallengeDurations) {
        currentDuration = duration
    }
    
    func updateStartAt(startAt: GroupStartAts) {
        currentStartAt = startAt
    }
}
