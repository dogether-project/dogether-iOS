//
//  TodoWriteViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/3/25.
//

import Foundation

struct TodoWriteViewDatas: BaseEntity {
    var groupId: Int
    var todo: String
    var todos: [WriteTodoEntity]
    var isShowKeyboard: Bool
    
    init(
        groupId: Int = 0,
        todo: String = "",
        todos: [WriteTodoEntity] = [],
        isShowKeyboard: Bool = true
    ) {
        self.groupId = groupId
        self.todo = todo
        self.todos = todos
        self.isShowKeyboard = isShowKeyboard
    }
}
