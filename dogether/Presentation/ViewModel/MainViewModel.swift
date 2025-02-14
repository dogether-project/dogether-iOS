//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit

class MainViewModel {
    private(set) var mainViewStatus: MainViewStatus
    private(set) var isBlockPanGesture: Bool
    
    // TODO: 추후 수정
    private(set) var groupName: String = "DND 작심삼일 탈출러"
    private(set) var currentDay: Int = 1
    private(set) var joinCode: String = "123456"
    private(set) var restDay: Int = 7
    
    private(set) var sheetStatus: SheetStatus = .normal
    
    // TODO: 추후 구현
    private(set) var time: String = "14:59:59"
    private(set) var timeProgress: CGFloat = 0.8
    
    // TODO: 추후 수정
    private(set) var currentFilter: FilterTypes = .all
    private(set) var todoList: [TodoInfo] = [
        TodoInfo(id: 0, content: "인증도 안한 투두", status: .waitCertificattion),
        TodoInfo(id: 1, content: "인증한 투두", status: .waitExamination),
        TodoInfo(id: 2, content: "노인정 투두", status: .reject),
        TodoInfo(id: 3, content: "인정 투두", status: .approve)
    ]
    
    // MARK: - Computed
    var todoListHeight: Int { 64 * todoList.count + 8 * (todoList.count - 1) }
    
    // MARK: - init
    init(status: MainViewStatus) {
        self.mainViewStatus = status
        self.isBlockPanGesture = status != .todoList
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
}
