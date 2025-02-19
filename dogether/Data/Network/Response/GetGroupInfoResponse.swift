//
//  GetGroupInfoResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetGroupInfoResponse: Decodable {
    let name: String
    let duration: Int
    let joinCode: String
    let endAt: String
    let remainingDays: Int
}
