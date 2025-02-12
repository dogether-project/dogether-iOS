//
//  CreateGroupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

class CreateGroupViewModel {
    private(set) var currentStep: CreateGroupSteps = .one
    private(set) var currentGroupName: String = ""
    private(set) var groupNameMaxLength: Int = 18
    private(set) var memberCount: Int = 10
    private(set) var todoLimit: Int = 5
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    func updateStep(step: CreateGroupSteps) async {
        currentStep = step
    }
    func updateGroupName(groupName: String?) async -> (String, String) {
        currentGroupName = groupName ?? ""
        return (currentGroupName, "\(currentGroupName.count)/\(groupNameMaxLength)")
    }
    func updateMemberCount(count: Int) async {
        memberCount = count
    }
    func updateTodoLimit(count: Int) async {
        todoLimit = count
    }
    func updateDuration(duration: GroupChallengeDurations) async {
        currentDuration = duration
    }
    func updateStartAt(startAt: GroupStartAts) async {
        currentStartAt = startAt
    }
}
