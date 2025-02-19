//
//  GroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import Foundation

struct GroupInfo {
    let name: String
    let duration: Int
    let joinCode: String
    let endAt: String
    let remainingDays: Int
    
    init(name: String = "", duration: Int = 0, joinCode: String = "", endAt: String = "", remainingDays: Int = 0) {
        self.name = name
        self.duration = duration
        self.joinCode = joinCode
        self.endAt = endAt
        self.remainingDays = remainingDays
    }
}
