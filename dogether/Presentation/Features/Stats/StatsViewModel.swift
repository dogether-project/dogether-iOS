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
    var statsViewStatus: StatsViewStatus = .hasData
    
    var dailyAchievements: [DailyAchievement] = [
        DailyAchievement(dayText: "1일차", value: 10),
        DailyAchievement(dayText: "2일차", value: 4),
        DailyAchievement(dayText: "3일차", value: 6),
        DailyAchievement(dayText: "4일차", value: 8),
//        DailyAchievement(dayText: "5일차", value: 2)
    ]

    
}



struct DailyAchievement {
    let dayText: String   // 예: "2일차"
    let value: Int        // 0~10 값
}
