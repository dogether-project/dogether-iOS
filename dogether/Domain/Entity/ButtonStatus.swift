//
//  ButtonStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit

enum ButtonStatus {
    case abled
    case disabled
    
    var textColor: UIColor {
        switch self {
        case .abled:
            return .grey800
        case .disabled:
            return .grey400
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .abled:
            return .blue300
        case .disabled:
            return .grey500
        }
    }
}
