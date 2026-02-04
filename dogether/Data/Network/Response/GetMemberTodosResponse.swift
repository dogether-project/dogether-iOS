//
//  GetMemberTodosResponse.swift
//  dogether
//
//  Created by seungyooooong on 4/29/25.
//

import Foundation

struct GetMemberTodosResponse: Decodable {
    let isMine: Bool
    let currentTodoHistoryToReadIndex: Int
    let todos: [TodoEntityInGetMemberTodos]
}

struct TodoEntityInGetMemberTodos: Decodable {
    let historyId: Int
    let todoId: Int
    let content: String
    let status: String
    let canRequestCertification: Bool
    let canRequestCertificationReview: Bool
    let certificationContent: String?
    let certificationMediaUrl: String?
    let isRead: Bool
    let reviewFeedback: String?
    
    init(
        historyId: Int,
        todoId: Int,
        content: String,
        status: String,
        canRequestCertification: Bool,
        canRequestCertificationReview: Bool,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        isRead: Bool,
        reviewFeedback: String? = nil
    ) {
        self.historyId = historyId
        self.todoId = todoId
        self.content = content
        self.status = status
        self.canRequestCertification = canRequestCertification
        self.canRequestCertificationReview = canRequestCertificationReview
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.isRead = isRead
        self.reviewFeedback = reviewFeedback
    }
}
