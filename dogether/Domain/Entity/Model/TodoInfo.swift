//
//  TodoInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

struct TodoInfo: Decodable {
    let id: Int
    let content: String
    var status: String
    var certificationContent: String?
    var certificationMediaUrl: String?
    var rejectReason: String?
    
    init(
        id: Int,
        content: String,
        status: String,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        rejectReason: String? = nil
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.rejectReason = rejectReason
    }
}

extension TodoInfo {
    init(from item: CertificationItem) {
        self.id = item.id
        self.content = item.content
        self.status = item.status
        self.certificationContent = item.certificationContent
        self.certificationMediaUrl = item.certificationMediaUrl
        self.rejectReason = item.rejectReason
    }
}

