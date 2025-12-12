//
//  SortViewDatas.swift
//  dogether
//
//  Created by yujaehong on 12/9/25.
//

import Foundation

struct SortViewDatas: BaseEntity {
    var index: Int
    let options: [SortOptions]
    var filter: FilterTypes
    
    init(
        index: Int = 0,
        options: [SortOptions] = SortOptions.allCases,
        filter: FilterTypes = .all
    ) {
        self.index = index
        self.options = options
        self.filter = filter
    }
}
