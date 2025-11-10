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
    private(set) var currentGroupName: String = ""
    private(set) var currentDuration: GroupChallengeDurations = .threeDays
    private(set) var currentStartAt: GroupStartAts = .today
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension GroupCreateViewModel {
    func updateGroupName(groupName: String?) {
        currentGroupName = groupName ?? ""
        
//        if currentGroupName.count > groupNameMaxLength {
//            currentGroupName = String(currentGroupName.prefix(groupNameMaxLength))
//        }
    }
    
    func updateMemberCount(count: Int) {
        guard groupCreateViewDatas.value.memberMinimum <= count,
              count <= groupCreateViewDatas.value.memberMaximum else { return }
        groupCreateViewDatas.update { $0.memberCount = count }
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
            groupName: currentGroupName,
            maximumMemberCount: groupCreateViewDatas.value.memberCount,
            startAt: currentStartAt,
            duration: currentDuration
        )
    }
}
