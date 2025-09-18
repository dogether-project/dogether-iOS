//
//  TodoEntity.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

struct TodoEntity: Decodable, BaseEntity {
    let id: Int
    let content: String
    var status: String
    var certificationContent: String?
    var certificationMediaUrl: String?
    var reviewFeedback: String?
    
    init(
        id: Int,
        content: String,
        status: String,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        reviewFeedback: String? = nil
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.reviewFeedback = reviewFeedback
    }
}

extension TodoEntity {
    init(from item: CertificationItem) {
        self.id = item.id
        self.content = item.content
        self.status = item.status
        self.certificationContent = item.certificationContent
        self.certificationMediaUrl = item.certificationMediaUrl
        self.reviewFeedback = item.reviewFeedback
    }
}

