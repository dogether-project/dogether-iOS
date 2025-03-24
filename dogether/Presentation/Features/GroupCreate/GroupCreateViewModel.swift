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
    
    private(set) var joinCode: String?
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
}

extension GroupCreateViewModel {
    func updateStep(step: CreateGroupSteps) {
        currentStep = step
    }
    
    func updateGroupName(groupName: String?) {
        currentGroupName = groupName ?? ""
        
        if currentGroupName.count > groupNameMaxLength {
            currentGroupName = String(currentGroupName.prefix(groupNameMaxLength))
        }
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

extension GroupCreateViewModel {
    func createGroup() async throws {
        let createGroupRequest = CreateGroupRequest(
            name: currentGroupName,
            maximumMemberCount: memberCount,
            startAt: currentStartAt,
            durationOption: currentDuration,
            maximumTodoCount: todoLimit
        )
        joinCode = try await groupCreateUseCase.createGroup(createGroupRequest: createGroupRequest)
    }
}
