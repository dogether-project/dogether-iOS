//
//  ReviewTodoRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct ReviewTodoRequest: Encodable {
    let result: String
    let rejectReason: String?
    
    init(result: ReviewResults, rejectReason: String? = nil) {
        self.result = result.rawValue
        self.rejectReason = rejectReason
    }
}

// TODO: 추후 Domain - Entity로 이동
enum ReviewResults: String {
    case approve = "APPROVE"
    case reject = "REJECT"
}
