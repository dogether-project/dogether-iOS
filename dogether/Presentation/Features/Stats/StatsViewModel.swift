//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

final class StatsViewModel {
    var statsViewStatus: StatsViewStatus = .empty

}

enum StatsViewStatus {
    case empty
    case hasData
}
