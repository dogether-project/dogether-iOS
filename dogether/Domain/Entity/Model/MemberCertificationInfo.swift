//
//  MemberCertificationInfo.swift
//  dogether
//
//  Created by seungyooooong on 4/22/25.
//

import Foundation

struct MemberCertificationInfo {
    let id: Int
    let content: String
    let certificationContent: String?
    var thumbnailStatus: ThumbnailStatus
    
    init(id: Int = 0, content: String = "", certificationContent: String? = nil, thumbnailStatus: ThumbnailStatus = .yet) {
        self.id = id
        self.content = content
        self.certificationContent = certificationContent
        self.thumbnailStatus = thumbnailStatus
    }
}
