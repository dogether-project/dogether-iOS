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
    var canRequestCertification: Bool
    var canRequestReview: Bool
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
        canRequestCertification: Bool = false,
        canRequestReview: Bool = false,
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
        self.canRequestCertification = canRequestCertification
        self.canRequestReview = canRequestReview
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.reviewFeedback = reviewFeedback
        self.createdAt = createdAt
    }
}
