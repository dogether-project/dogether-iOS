//
//  CertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import Foundation

struct CertificationViewDatas: BaseEntity {
    var todo: TodoEntity
    
    // FIXME: TodoEntity 기본값 수정
    init(todo: TodoEntity = TodoEntity(id: 0, content: "", status: "")) {
        self.todo = todo
    }
}
