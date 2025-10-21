//
//  CertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import Foundation

struct CertificationViewDatas: BaseEntity {
    var todos: [TodoEntity]
    var index: Int
    
    init(todos: [TodoEntity] = [], index: Int = 0) {
        self.todos = todos
        self.index = index
    }
}
