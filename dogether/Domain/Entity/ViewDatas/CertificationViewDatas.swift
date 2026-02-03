//
//  CertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import Foundation

struct CertificationViewDatas: BaseEntity {
    var title: String
    var isMine: Bool?
    var todos: [TodoEntity]
    var index: Int
    
    init(
        title: String = "",
        isMine: Bool? = nil,
        todos: [TodoEntity] = [],
        index: Int = 0,
    ) {
        self.title = title
        self.isMine = isMine
        self.todos = todos
        self.index = index
    }
}
