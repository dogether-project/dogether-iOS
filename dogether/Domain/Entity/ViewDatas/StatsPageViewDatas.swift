//
//  StatsPageViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/18/25.
//

struct StatsPageViewDatas: BaseEntity {
    var status: StatsViewStatus

    init(
        status: StatsViewStatus = .empty
    ) {
        self.status = status
    }
}
