//
//  MainViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation

class MainViewModel {
    private(set) var groupName: String = "DND 작심삼일 탈출러"
    private(set) var currentDay: Int = 1
    private(set) var joinCode: String = "123456"
    private(set) var restDay: Int = 7
    
    private(set) var isBlockPanGesture = false
    private(set) var sheetStatus: SheetStatus = .normal
    
    
    func setIsBlockPanGesture(_ isBlockPanGesture: Bool) {
        self.isBlockPanGesture = isBlockPanGesture
    }
    func setSheetStatus(_ sheetStatus: SheetStatus) {
        self.sheetStatus = sheetStatus
    }
}
