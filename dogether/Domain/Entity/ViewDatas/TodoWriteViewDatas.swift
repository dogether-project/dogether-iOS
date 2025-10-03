//
//  TodoWriteViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/3/25.
//

import Foundation

struct TodoWriteViewDatas: BaseEntity {
    var groupId: Int = 0
    var todos: [WriteTodoEntity] = []
    
    init(groupId: Int = 0, todos: [WriteTodoEntity] = []) {
        self.groupId = groupId
        self.todos = todos
    }
}
