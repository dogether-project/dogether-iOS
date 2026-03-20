//
//  ButtonStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

enum ButtonStatus {
    case enabled
    case disabled
    
    var textColor: UIColor {
        switch self {
        case .enabled:
            return Color.Text.inverse
        case .disabled:
            return Color.Text.disabled
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return Color.Background.primary
        case .disabled:
            return Color.Background.disabled
        }
    }
}
