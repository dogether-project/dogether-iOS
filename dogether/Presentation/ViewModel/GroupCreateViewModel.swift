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
    
    func updateStep(step: CreateGroupSteps) async {
        currentStep = step
    }
    
    // TODO: 추후 완성
    func completeAction(updateStepUI: @escaping () -> Void) -> Void {
        Task { @MainActor in
            if currentStep == .four {
                let completeViewController = CompleteViewController(type: .create)
                completeViewController.viewModel.joinCode = await getJoinCode()
                NavigationManager.shared.setNavigationController(completeViewController)
            } else {
                guard let nextStep = CreateGroupSteps(rawValue: currentStep.rawValue + 1) else { return }
                await updateStep(step: nextStep)
                updateStepUI()
            }
        }
    }
    
    func getJoinCode() async -> String {
        // TODO: 추후 UseCase 추가
        let createGroupRequest = CreateGroupRequest(
            name: currentGroupName,
            maximumMemberCount: memberCount,
            startAt: currentStartAt,
            durationOption: currentDuration,
            maximumTodoCount: todoLimit
        )
//        do {
//            let response: CreateGroupResponse = try await NetworkManager.shared.request(GroupsRouter.createGroup(createGroupRequest: createGroupRequest))
//            
//            return response.joinCode
//        } catch {
//            // TODO: API 실패 시 처리에 대해 추후 논의
//        }
        return ""
    }
    
    func updateGroupName(groupName: String?) async -> (String, ButtonStatus) {
        currentGroupName = groupName ?? ""
        let buttonStatus: ButtonStatus = currentStep == .one && currentGroupName.count > 0 ? .enabled : .disabled
        return (currentGroupName, buttonStatus)
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
