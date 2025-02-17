//
//  TodoInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

struct TodoInfo {
    let id: Int
    let content: String
    var status: TodoStatus
    var mediaUrl: String?
    var todoContent: String?
    var rejectReason: String?
    
    init(id: Int, content: String, status: TodoStatus, mediaUrl: String? = nil, todoContent: String? = nil, rejectReason: String? = nil) {
        self.id = id
        self.content = content
        self.status = status
        self.mediaUrl = mediaUrl
        self.todoContent = todoContent
        self.rejectReason = rejectReason
    }
}
