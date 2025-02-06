//
//  GetReviewResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

struct GetReviewResponse: ReviewInfo, Decodable {
    let id: Int
    let content: String
    let mediaUrls: [String]
    let todoContent: String
}
