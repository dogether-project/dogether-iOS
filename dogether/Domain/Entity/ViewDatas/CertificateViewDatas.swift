//
//  CertificateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import Foundation

struct CertificateViewDatas: BaseEntity {
    var todo: TodoEntity
    
    init(
        todo: TodoEntity = TodoEntity(id: 0, content: "", status: .waitCertification)
    ) {
        self.todo = todo
    }
}
