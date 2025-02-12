//
//  Directions.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum Directions {
    case minus
    case plus
    
    var tag: Int {
        switch self {
        case .minus:
            return -1
        case .plus:
            return 1
        }
    }
}
