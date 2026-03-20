//
//  ReviewTodoRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct ReviewTodoRequest: Encodable {
    let result: String
    let reviewFeedback: String
    
    init(result: ReviewStatus, reviewFeedback: String) {
        self.result = result.rawValue
        self.reviewFeedback = reviewFeedback
    }
}
