//
//  GroupStatsResponse.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

struct GroupStatsResponse: Decodable {
//    let group: GroupEntityInGroupStats  // MARK: 사용 안함
    let certificationPeriods: [CertificationPeriodEntityInGroupStats]
    let ranking: RankingEntityInGroupStats
    let stats: StatsEntityInGroupStats
}

// MARK: 사용 안함
struct GroupEntityInGroupStats: Decodable {
    let name: String
    let maximumMemberCount: Int
    let currentMemberCount: Int
    let joinCode: String
    let endAt: String
}

struct CertificationPeriodEntityInGroupStats: Decodable {
    let day: Int
    let createdCount: Int
    let certificatedCount: Int
    let certificationRate: Int
}

struct RankingEntityInGroupStats: Decodable {
    let totalMemberCount: Int
    let myRank: Int
}

struct StatsEntityInGroupStats: Decodable {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}
