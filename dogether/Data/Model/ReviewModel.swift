//
//  ReviewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

struct ReviewModel: ReviewInfo, Codable {
    let id: Int
    let content: String
    let mediaUrls: [String]
    let todoContent: String
}
