//
//  GetTeamSummaryResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetTeamSummaryResponse: Decodable {
    let ranking: [RankingModel]
}
