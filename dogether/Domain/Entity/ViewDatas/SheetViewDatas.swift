//
//  SheetViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/14/25.
//

import Foundation

struct SheetViewDatas: BaseEntity {
    var alpha: CGFloat
    var date: String
    var dateOffset: Int
    
    init(alpha: CGFloat = 1.0, date: String = "2000.01.01", dateOffset: Int = 0) {
        self.alpha = alpha
        self.date = date
        self.dateOffset = dateOffset
    }
}
