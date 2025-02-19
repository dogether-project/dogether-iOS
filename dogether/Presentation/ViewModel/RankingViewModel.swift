//
//  RankingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

final class RankingViewModel {
    
    private(set) var ranking: [RankingModel] = []
    
    func getTeamSummary() async throws {
        let response: GetTeamSummaryResponse = try await NetworkManager.shared.request(GroupsRouter.getTeamSummary)
        self.ranking = response.ranking
    }
}
