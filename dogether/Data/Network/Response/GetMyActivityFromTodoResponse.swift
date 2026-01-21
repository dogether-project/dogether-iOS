//
//  GetMyActivityFromTodoResponse.swift
//  dogether
//
//  Created by seungyooooong on 1/20/26.
//

import Foundation

struct GetMyActivityFromTodoResponse: Decodable {
    let certifications: [CertificationEntityInGetMyActivityFromTodoResponse]
}


struct CertificationEntityInGetMyActivityFromTodoResponse: Decodable {
    let id: Int
    let content: String
    var status: String
    var canRequestCertificationReview: Bool
    var certificationContent: String
    var certificationMediaUrl: String
    var reviewFeedback: String?
}
