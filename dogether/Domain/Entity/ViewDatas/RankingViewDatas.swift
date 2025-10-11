//
//  RankingViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/11/25.
//

import Foundation

struct RankingViewDatas: BaseEntity {
    var groupId: Int
    
    init(groupId: Int = 0) {
        self.groupId = groupId
    }
}
