//
//  TodoEntity.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

struct TodoEntity: BaseEntity {
    let historyId: Int? // MARK: readTodo에서 사용
    let id: Int
    let content: String
    var status: TodoStatus
    var thumbnailStatus: ThumbnailStatus
    var canRemindCertification: Bool
    var canRemindReview: Bool
    var certificationContent: String?
    var certificationMediaUrl: String?
    var reviewFeedback: String?
    var createdAt: String?
    
    init(
        historyId: Int? = nil,
        id: Int,
        content: String,
        status: TodoStatus,
        thumbnailStatus: ThumbnailStatus = .yet,
        canRemindCertification: Bool = false,
        canRemindReview: Bool = false,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        reviewFeedback: String? = nil,
        createdAt: String? = nil
    ) {
        self.historyId = historyId
        self.id = id
        self.content = content
        self.status = status
        self.thumbnailStatus = thumbnailStatus
        self.canRemindCertification = canRemindCertification
        self.canRemindReview = canRemindReview
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.reviewFeedback = reviewFeedback
        self.createdAt = createdAt
    }
}

extension TodoEntity {
    func with(createdAt: String) -> Self {
        var todo = self
        todo.createdAt = createdAt
        return todo
    }
}
