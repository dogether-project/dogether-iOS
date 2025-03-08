//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit

final class MainViewModel {
    private let mainUseCase: MainUseCase
    
    private(set) var mainViewStatus: MainViewStatus = .emptyList
    private(set) var isBlockPanGesture: Bool = true
    
    // TODO: 추후 수정
    private(set) var groupInfo: GroupInfo = GroupInfo()
    
    private(set) var sheetStatus: SheetStatus = .normal
    
    // TODO: 추후 구현
    private(set) var time: String = "14:59:59"
    private(set) var timeProgress: CGFloat = 0.8
    
    private(set) var dateOffset: Int = 0
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = []
    
    // MARK: - Computed
    var todoListHeight: Int { todoList.isEmpty ? 0 : 64 * todoList.count + 8 * (todoList.count - 1) }
    
    init() {
        let mainRepository = MainRepository()
        self.mainUseCase = MainUseCase(repository: mainRepository)
    }
    
    func loadMainView(completeAction: @escaping () -> Void) {
        Task {
            mainViewStatus = try await mainUseCase.getMainViewStatus()
            groupInfo = try await mainUseCase.getGroupInfo()
            try await updateListInfo()
            await MainActor.run { completeAction() }
        }
    }
    
    func didTapTodoItem(todo: TodoInfo) {
        if TodoStatus(rawValue: todo.status) == .waitCertificattion {
            PopupManager.shared.showPopup(type: .certification, completion: {
                // TODO: 추후에 인증을 성공했을 때 UI 업데이트 등 추가
            }, todoInfo: todo)
        } else {
            PopupManager.shared.showPopup(type: .certificationInfo, todoInfo: todo)
        }
    }
    
    func setIsBlockPanGesture(_ isBlockPanGesture: Bool) {
        self.isBlockPanGesture = isBlockPanGesture
    }
    
    func updateSheetStatus(_ sheetStatus: SheetStatus) {
        self.sheetStatus = sheetStatus
    }
    
    func updateFilter(filter: FilterTypes, completeAction: @escaping () -> Void) {
        self.currentFilter = filter
        
        Task {
            try await updateListInfo()
            await MainActor.run { completeAction() }
        }
    }
    
    private func updateListInfo() async throws {
        if mainViewStatus == .beforeStart { return }
        
        todoList = try await mainUseCase.getTodoList(dateOffset: dateOffset, currentFilter: currentFilter)
        mainViewStatus = currentFilter == .all && todoList.isEmpty ? .emptyList : .todoList
        isBlockPanGesture = await todoListHeight < Int(UIScreen.main.bounds.height - (SheetStatus.normal.offset + 140 + 48))
    }
}

// MARK: navigate
extension MainViewModel {
    func navigateToTodoWriteView() {
        mainUseCase.navigateToTodoWriteView(maximumTodoCount: groupInfo.maximumTodoCount)
    }
    
    func navigateToRankingView() {
        mainUseCase.navigateToRankingView()
    }
}
