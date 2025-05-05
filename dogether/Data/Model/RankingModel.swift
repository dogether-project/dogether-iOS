//
//  RankingModel.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import UIKit

enum HistoryReadStatus: String {
    case readYet = "READYET"
    case readAll = "READALL"
    
    var colors: [CGColor] {
        switch self {
        case .readYet:
            return [UIColor.blue300.cgColor, UIColor.dogetherYellow.cgColor, UIColor.dogetherRed.cgColor]
        case .readAll:
            return [UIColor.grey500.cgColor, UIColor.grey500.cgColor]
        }
    }
}

struct RankingModel {
    let memberId: Int
    let rank: Int
    let profileImageUrl: String
    let name: String
    let historyReadStatus: HistoryReadStatus?
    let achievementRate: Int
}
