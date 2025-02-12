//
//  PresignedUrlRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

struct PresignedUrlRequest: Encodable {
    let todoId: Int
    let uploadFileTypes: [FileTypes]
    
    init(todoId: Int, uploadFileTypes: [FileTypes]) {
        self.todoId = todoId
        self.uploadFileTypes = uploadFileTypes
    }
}
