//
//  ChallengeGroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import Foundation

struct ChallengeGroupInfo {
    let id: Int
    let name: String
    let currentMember: Int
    let maximumMember: Int
    let joinCode: String
    let endDate: String
    let duration: Int
    let progress: Float
    
    init(
        id: Int = 0,
        name: String = "",
        currentMember: Int = 0,
        maximumMember: Int = 0,
        joinCode: String = "00000000",
        endDate: String = "00.00.00",
        duration: Int = 0,
        progress: Float = 0
    ) {
        self.id = id
        self.name = name
        self.currentMember = currentMember
        self.maximumMember = maximumMember
        self.joinCode = joinCode
        self.endDate = endDate
        self.duration = duration
        self.progress = progress
    }
}
