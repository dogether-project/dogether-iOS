//
//  TodoFilterType.swift
//  dogether
//
//  Created by yujaehong on 8/25/25.
//

import UIKit

enum TodoFilterType: String, CaseIterable {
    case all = "전체"
    case waitCertification = "CERTIFY_PENDING"
    case waitExamination = "REVIEW_PENDING"
    case reject = "REJECT"
    case approve = "APPROVE"
    
    var tag: Int {
        switch self {
        case .all:
            return 0
        case .waitCertification:
            return 0
        case .waitExamination:
            return 1
        case .reject:
            return 2
        case .approve:
            return 3
        }
    }
    
    var image: UIImage? {
        switch self {
        case .all:
            return nil
        case .waitCertification:
            return nil
        case .waitExamination:
            return .wait
        case .reject:
            return .reject
        case .approve:
            return .approve
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .all, .approve:
            return .blue300
        case .waitCertification:
            return .grey300
        case .waitExamination:
            return .dogetherYellow
        case .reject:
            return .dogetherRed
        }
    }
    
    var width: CGFloat {
        switch self {
        case .all:
            return 48
        case .waitCertification:
            return 52
        case .waitExamination:
            return 89
        case .reject:
            return 74
        case .approve:
            return 62
        }
    }
    
    var text: String {
        switch self {
        case .all:
            return "전체"
        case .waitCertification:
            return "미인증"
        case .waitExamination:
            return "검사 대기"
        case .reject:
            return "노인정"
        case .approve:
            return "인정"
        }
    }
    
    var emptyDescription: String {
        switch self {
        case .waitExamination:
            return "검사 대기 중인 투두가 없어요"
        case .reject:
            return "노인정받은 투두가 없어요"
        case .approve:
            return "인정받은 투두가 없어요"
        default:
            return ""
        }
    }
    
    var reviewResult: ReviewResults? {
        switch self {
        case .reject:
            return .reject
        case .approve:
            return .approve
        default:
            return nil
        }
    }
    
}
