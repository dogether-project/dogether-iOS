//
//  GroupCreateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

struct GroupCreateViewDatas: BaseEntity {
    var step: CreateGroupSteps
    
    init(
        step: CreateGroupSteps = .one,
    ) {
        self.step = step
    }
}
