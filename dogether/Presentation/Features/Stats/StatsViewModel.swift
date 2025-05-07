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

protocol StatsViewModelDelegate: AnyObject {
    func didFetchStatsSucceed()
}

final class StatsViewModel {

    private let useCase: StatsUseCase
    weak var delegate: StatsViewModelDelegate?
    
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

    init() {
        let repository = DIManager.shared.getStatsRepository()
        self.useCase = StatsUseCase(repository: repository)
    }

    func fetchStats(groupId: Int) {
        Task {
            do {
                let response = try await useCase.fetchGroupStats(groupId: groupId)
                apply(response: response)
                delegate?.didFetchStatsSucceed()
            } catch {
                statsViewStatus = .empty
                throw error
            }
        }
    }

    private func apply(response: GroupStatsResponse) {
        let data = response.data
        statsViewStatus = .hasData
        groupName = data.groupInfo.name
        endDate = data.groupInfo.endAt
        maximumMemberCount = data.groupInfo.maximumMemberCount
        currentMemberCount = data.groupInfo.currentMemberCount
        joinCode = data.groupInfo.joinCode

        myRank = data.ranking.myRank
        totalMembers = data.ranking.totalMemberCount
        statsSummary = data.stats
        dailyAchievements = data.certificationPeriods
    }
}
