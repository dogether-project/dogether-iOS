//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

import RxRelay

final class MainViewModel {
    private let groupUseCase: GroupUseCase
    private let challengeGroupsUseCase: ChallengeGroupUseCase
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var groupViewDatas = BehaviorRelay<GroupViewDatas>(value: GroupViewDatas())
    private(set) var sheetViewDatas = BehaviorRelay<SheetViewDatas>(
        value: SheetViewDatas(date: DateFormatterManager.formattedDate())
    )
    
    private(set) var timer: Timer?
    private(set) var time: String = "23:59:59"
    private(set) var timeProgress: CGFloat = 0.0
    
    private(set) var dateOffset: Int = 0
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoEntity] = []
    

    // MARK: - Computed
    var todoListHeight: Int { todoList.isEmpty ? 0 : 64 * todoList.count + 8 * (todoList.count - 1) }
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let challengeGroupsRepository = DIManager.shared.getChallengeGroupsRepository()
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.challengeGroupsUseCase = ChallengeGroupUseCase(repository: challengeGroupsRepository)
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
}

// MARK: - get
extension MainViewModel {
    func getGroups() async throws -> GroupViewDatas {
        return try await groupUseCase.getGroups()
    }
    
    func getTodoList(dateOffset: Int, groupId: Int) async throws -> [TodoEntity] {
        let date = DateFormatterManager.formattedDate(dateOffset).split(separator: ".").joined(separator: "-")
        return try await challengeGroupsUseCase.getMyTodos(groupId: groupId, date: date)
    }
    
    func getReviews() async throws -> [ReviewModel] {
        try await todoCertificationsUseCase.getReviews()
    }
}

// MARK: - set
extension MainViewModel {
    func setDateOffset(offset: Int) {
        self.dateOffset = offset
    }
    
    func setFilter(filter: FilterTypes) {
        if self.currentFilter == filter {
            self.currentFilter = .all
        } else {
            self.currentFilter = filter
        }
    }
    
    func setSheetViewDatasForCurrentGroup(currentGroup: GroupEntity) async throws {
        if currentGroup.status == .ready {
            sheetViewDatas.update { $0.status = .timer }
            return
        }
        
        let dateOffset = sheetViewDatas.value.dateOffset
        if currentGroup.status == .dDay && dateOffset == 0 {
            sheetViewDatas.update { $0.status = .done }
            return
        }
        
        let todoList = try await getTodoList(dateOffset: dateOffset, groupId: currentGroup.id)
        sheetViewDatas.update {
            $0.todoList = todoList
            $0.status = dateOffset == 0 && todoList.isEmpty ? .createTodo :
            dateOffset == 0 && todoList.count > 0 ? .certificateTodo :
            dateOffset < 0 && todoList.isEmpty ? .emptyList : .todoList
        }
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
        }
    }
    
    private func updateTimerInfo(remainTime: TimeInterval, updateTimer: @escaping () -> Void) {
        self.time = remainTime.formatToHHmmss()
        self.timeProgress = remainTime.getTimeProgress()
        Task { @MainActor in updateTimer() }
    }
}

extension MainViewModel {
    func saveLastSelectedGroupIndex(index: Int) {
        Task {
            try await groupUseCase.saveLastSelectedGroup(groupId: groupViewDatas.value.groups[index].id)
        }
    }
}
