//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

final class MainViewModel {
    private let mainUseCase: MainUseCase
    private let groupUseCase: GroupUseCase
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var rankings: [RankingModel]?
    
    var challengeGroupInfos: [ChallengeGroupInfo] = []
    
    var currentGroup: ChallengeGroupInfo {
        challengeGroupInfos[currentChallengeIndex]
    }
    
    private(set) var currentChallengeIndex: Int = 0
    
    private(set) var sheetStatus: SheetStatus = .normal
    private(set) var isBlockPanGesture: Bool = true
    
    private(set) var timer: Timer?
    private(set) var time: String = "23:59:59"
    private(set) var timeProgress: CGFloat = 0.0
    
    private(set) var dateOffset: Int = 0
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = []
    
    // MARK: - Computed
    var todoListHeight: Int { todoList.isEmpty ? 0 : 64 * todoList.count + 8 * (todoList.count - 1) }
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        
        self.mainUseCase = MainUseCase()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
}

// MARK: - load view
extension MainViewModel {
    func loadMainView() async throws {
        challengeGroupInfos = try await groupUseCase.getChallengeGroupInfos()
    }
    
    func getReviews() async throws -> [ReviewModel] {
        try await todoCertificationsUseCase.getReviews()
    }
    
    func checkAuthorization() async throws {
        let userNoti = UNUserNotificationCenter.current()
        let settings = await userNoti.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            try await userNoti.requestAuthorization(options: [.alert, .badge, .sound])
        case .denied:
            SystemManager().openSettingApp()    // FIXME: show AlertPopup
        default:    // MARK: .authorized, .provisional, .ephemeral
            break
        }
    }
}

// MARK: - set
extension MainViewModel {
    func setDateOffset(offset: Int) {
        self.dateOffset = offset
    }
}

// MARK: - ready
extension MainViewModel {
    func startCountdown(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        checkRemainTime(updateTimer: updateTimer, updateList: updateList)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.checkRemainTime(updateTimer: updateTimer, updateList: updateList)
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkRemainTime(updateTimer: @escaping () -> Void, updateList: @escaping () -> Void) {
        let remainTime = Date().getRemainTime()
        
        if remainTime > 0 {
            updateTimerInfo(remainTime: remainTime, updateTimer: updateTimer)
        } else {
            stopCountdown()
            updateListInfo(updateList: updateList)
        }
    }
    
    private func updateTimerInfo(remainTime: TimeInterval, updateTimer: @escaping () -> Void) {
        self.time = remainTime.formatToHHmmss()
        self.timeProgress = remainTime.getTimeProgress()
        Task { @MainActor in updateTimer() }
    }
    
    private func updateListInfo(updateList: @escaping () -> Void) {
        Task {
            let (date, status) = try await mainUseCase.getTodosInfo(dateOffset: dateOffset, currentFilter: currentFilter)
            todoList = try await challengeGroupsUseCase.getMyTodos(groupId: currentGroup.id, date: date, status: status)
            isBlockPanGesture = await todoListHeight < Int(UIScreen.main.bounds.height - (SheetStatus.normal.offset + 140 + 48))
            await MainActor.run { updateList() }
        }
    }
}
    
// MARK: - todoList
extension MainViewModel {
    func updateFilter(filter: FilterTypes) {
        self.currentFilter = filter
    }
    
    func updateListInfo() async throws {
        let (date, status) = try await mainUseCase.getTodosInfo(dateOffset: dateOffset, currentFilter: currentFilter)
        todoList = try await challengeGroupsUseCase.getMyTodos(groupId: currentGroup.id, date: date, status: status)
        isBlockPanGesture = await todoListHeight < Int(UIScreen.main.bounds.height - (SheetStatus.normal.offset + 140 + 48))
    }
}

// MARK: - about sheet
extension MainViewModel {
    func setIsBlockPanGesture(_ isBlockPanGesture: Bool) {
        self.isBlockPanGesture = isBlockPanGesture
    }
    
    func getNewOffset(from currentOffset: CGFloat, with translation: CGFloat) -> CGFloat {
        switch sheetStatus {
        case .expand:
            if translation > 0 { return min(SheetStatus.normal.offset, SheetStatus.expand.offset + translation) }
            return currentOffset
        case .normal:
            if translation < 0 { return max(0, SheetStatus.normal.offset + translation) }
            return currentOffset
        }
    }
    
    func updateSheetStatus(with translation: CGFloat) -> SheetStatus {
        switch sheetStatus {
        case .expand:
            sheetStatus = translation > 100 ? .normal : .expand
        case .normal:
            sheetStatus = translation < -100 ? .expand : .normal
        }
        return sheetStatus
    }
    
    func setChallengeIndex(index: Int) {
        self.currentChallengeIndex = index
    }
}
