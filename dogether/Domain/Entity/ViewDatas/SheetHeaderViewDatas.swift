//
//  SheetHeaderViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/14/25.
//

import Foundation

struct SheetHeaderViewDatas: BaseEntity {
    var date: String
    var dateOffset: Int
    
    init(date: String = "2000.01.01", dateOffset: Int = 0) {
        self.date = date
        self.dateOffset = dateOffset
    }
}
