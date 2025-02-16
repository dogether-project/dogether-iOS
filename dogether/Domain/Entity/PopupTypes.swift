//
//  PopupTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import Foundation

enum PopupTypes {
    case certification
    case certificationInfo
    
    var popupHeight: CGFloat {
        switch self {
        case .certification:
            return 240
        case .certificationInfo:
            return 581
        }
    }
}
