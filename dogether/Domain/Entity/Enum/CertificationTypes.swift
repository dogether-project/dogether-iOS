//
//  CertificationTypes.swift
//  dogether
//
//  Created by seungyooooong on 11/27/25.
//

import UIKit

enum CertificationTypes {
    case achievement
    case review(ReviewStatus)

    var iconImage: UIImage {
        switch self {
        case .achievement:
            return .achievement
        case .review(let status):
            return status.image ?? .achievement
        }
    }

    var text: String {
        switch self {
        case .achievement:
            return "달성"
        case .review(let status):
            return status.text
        }
    }

    var titleLabelWidth: CGFloat {
        switch self {
        case .achievement:
            return 25
        case .review(let status):
            switch status {
            case .pending: return 49
            case .approve: return 25
            case .reject: return 37
            }
        }
    }
}
