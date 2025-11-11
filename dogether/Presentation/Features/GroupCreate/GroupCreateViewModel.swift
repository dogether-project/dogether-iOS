//
//  GroupCreateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation

import RxRelay

final class GroupCreateViewModel {
    private let groupUseCase: GroupUseCase
    
    private(set) var groupCreateViewDatas = BehaviorRelay<GroupCreateViewDatas>(value: GroupCreateViewDatas())
    
    private(set) var joinCode: String?
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupCreateViewModel {
    func updateStep(direction: Directions) {
        guard let step = CreateGroupSteps(
            rawValue: groupCreateViewDatas.value.step.rawValue + direction.tag
        ) else { return }
        groupCreateViewDatas.update { $0.step = step }
    }
    
    func updateGroupName(groupName: String?, groupNameMaxLength: Int) {
        groupCreateViewDatas.update {
            $0.groupName = groupUseCase.prefixGroupName(groupName: groupName, maxLength: groupNameMaxLength)
        }
    }
    
    func updateMemberCount(count: Int, min: Int, max: Int) {
        let isValidate = groupUseCase.validateMemberCount(count: count, min: min, max: max)
        if isValidate { groupCreateViewDatas.update { $0.memberCount = count } }
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
        joinCode = try await groupUseCase.createGroup(
            groupName: groupCreateViewDatas.value.groupName,
            maximumMemberCount: groupCreateViewDatas.value.memberCount,
            startAt: currentStartAt,
            duration: currentDuration
        )
    }
}
