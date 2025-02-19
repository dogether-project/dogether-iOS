//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit

final class MainViewModel {
    private(set) var mainViewStatus: MainViewStatus
    private(set) var isBlockPanGesture: Bool = true
    
    // TODO: 추후 수정
    private(set) var groupInfo: GroupInfo = GroupInfo()
    
    private(set) var sheetStatus: SheetStatus = .normal
    
    // TODO: 추후 구현
    private(set) var time: String = "14:59:59"
    private(set) var timeProgress: CGFloat = 0.8
    
    // TODO: 추후 수정
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = []
    
    // MARK: - Computed
    var todoListHeight: Int { 64 * todoList.count + 8 * (todoList.count - 1) }
    
    // MARK: - init
    init(status: MainViewStatus) {
        self.mainViewStatus = status
    }
    
    func setIsBlockPanGesture(_ isBlockPanGesture: Bool) {
        self.isBlockPanGesture = isBlockPanGesture
    }
    func updateSheetStatus(_ sheetStatus: SheetStatus) {
        self.sheetStatus = sheetStatus
    }
    func updateFilter(_ filter: FilterTypes) {
        self.currentFilter = filter
    }
    func setTodoList(_ todoList: [TodoInfo]) {
        self.todoList = todoList
        self.isBlockPanGesture = self.todoListHeight < Int(UIScreen.main.bounds.height - (SheetStatus.normal.offset + 140))
    }
    
    func getGroupStatus() async throws {
        let response: GetGroupStatusResponse = try await NetworkManager.shared.request(GroupsRouter.getGroupStatus)
        // TODO: 추후 수정 (FINISHED에 대한 정의가 제대로 나오면 MainViewStatus와 결합하며 enum으로 수정)
        mainViewStatus = response.status == "READY" ? .beforeStart : .emptyList
    }
    
    func getGroupInfo() async throws {
        let response: GetGroupInfoResponse = try await NetworkManager.shared.request(GroupsRouter.getGroupInfo)
        self.groupInfo = GroupInfo(
            name: response.name,
            duration: response.duration,
            joinCode: response.joinCode,
            endAt: response.endAt,
            remainingDays: response.remainingDays
        )
    }
}
