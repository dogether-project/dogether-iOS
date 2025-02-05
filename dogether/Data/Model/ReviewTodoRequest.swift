//
//  ReviewTodoRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

// TODO: 추후 수정
struct ReviewTodoRequest: Encodable {
    let result: String = "REJECT"   // TODO: 추후 enum 생성
    let rejectReason: String? = "그게 정말 최선이야?"
}
