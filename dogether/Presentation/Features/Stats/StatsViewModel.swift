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
    var maximumMemberCount: Int = 0
    var currentMemberCount: Int = 0
    var joinCode: String = ""
    
    var dailyAchievements: [CertificationPeriod] = []
    var myRank: Int = 0
    var totalMembers: Int = 0
    var statsSummary: Stats?
}

extension StatsViewModel {
    func loadMockDataFromFile() {
        print(#function)
        guard let url = Bundle.main.url(forResource: "StatsMock2", withExtension: "json") else {
            print("❌ mock.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(GroupStatsResponse.self, from: data)
            let response = decoded.data
            
            statsViewStatus = .hasData
            
            groupName = response.groupInfo.name
            endDate = response.groupInfo.endAt
            maximumMemberCount = response.groupInfo.maximumMemberCount
            currentMemberCount = response.groupInfo.currentMemberCount
            joinCode = response.groupInfo.joinCode
                       
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
    let groupInfo: GroupInfo2
    let certificationPeriods: [CertificationPeriod]
    let ranking: Ranking
    let stats: Stats
}

struct GroupInfo2: Decodable {
    let name: String
    let maximumMemberCount: Int
    let currentMemberCount: Int
    let joinCode: String
    let endAt: String
}

struct CertificationPeriod: Decodable {
    let day: Int
    let createdCount: Int
    let certificatedCount: Int
    let certificationRate: Int
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
