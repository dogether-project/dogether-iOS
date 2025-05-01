//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

enum StatsViewStatus {
    case empty
    case hasData
}

final class StatsViewModel {
    var statsViewStatus: StatsViewStatus = .empty
    
    var groupName: String = ""
    var endDate: String = ""
    var dailyAchievements: [CertificationPeriod] = []
    var myRank: Int = 0
    var totalMembers: Int = 0
    var statsSummary: Stats?
}

extension StatsViewModel {
    func loadMockDataFromFile() {
        print(#function)
        guard let url = Bundle.main.url(forResource: "StatsMock", withExtension: "json") else {
            print("❌ mock.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(GroupStatsResponse.self, from: data)
            let response = decoded.data
            
            statsViewStatus = .hasData
            
            groupName = response.name
            endDate = response.endAt
            myRank = response.ranking.myRank
            totalMembers = response.ranking.totalMemberCount
            statsSummary = response.stats
            dailyAchievements = response.certificationPeriods
        } catch {
            print("❌ JSON 파싱 실패: \(error)")
        }
    }
}

struct GroupStatsResponse: Decodable {
    let code: String
    let message: String
    let data: GroupStatsData
}

struct GroupStatsData: Decodable {
    let name: String
    let endAt: String
    let certificationPeriods: [CertificationPeriod]
    let ranking: Ranking
    let stats: Stats
}

struct CertificationPeriod: Decodable { // 여기
    let day: Int // n일차
    let createdCount: Int // 8개중
    let certificatedCount: Int // 2개 인증
    let certificationRate: Int // 몇퍼센트인지
}

struct Ranking: Decodable {
    let totalMemberCount: Int
    let myRank: Int
}

struct Stats: Decodable {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}

