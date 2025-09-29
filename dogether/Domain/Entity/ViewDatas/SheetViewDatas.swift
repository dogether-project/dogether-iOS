//
//  SheetViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/14/25.
//

import Foundation

struct SheetViewDatas: BaseEntity {
    var alpha: CGFloat
    var sheetStatus: SheetStatus
    var yOffset: CGFloat
    var date: String
    var dateOffset: Int
    var status: SheetViewStatus?
    var isScrollOnTop: Bool
    var todoList: [TodoEntity]
    var filter: FilterTypes
    
    init(
        alpha: CGFloat = 1.0,
        sheetStatus: SheetStatus = .normal,
        yOffset: CGFloat = SheetStatus.normal.offset,
        date: String = "2000.01.01",
        dateOffset: Int = 0,
        status: SheetViewStatus? = nil,
        isScrollOnTop: Bool = true,
        todoList: [TodoEntity] = [],
        filter: FilterTypes = .all
    ) {
        self.alpha = alpha
        self.sheetStatus = sheetStatus
        self.yOffset = yOffset
        self.date = date
        self.dateOffset = dateOffset
        self.status = status
        self.isScrollOnTop = isScrollOnTop
        self.todoList = todoList
        self.filter = filter
    }
}
