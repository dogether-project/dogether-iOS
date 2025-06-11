//
//  TodoStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

enum TodoStatus: String, CaseIterable {
    case waitCertification = "CERTIFY_PENDING"
    case waitExamination = "REVIEW_PENDING"
    case reject = "REJECT"
    case approve = "APPROVE"
    
    var tag: Int {
        switch self {
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
    
    var text: String {
        switch self {
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
    
    var filterType: FilterTypes {
        switch self {
        case .waitCertification:
            return .all // FIXME: 추후 미인증으로 수정
        case .waitExamination:
            return .wait
        case .approve:
            return .approve
        case .reject:
            return .reject
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .waitCertification:
            return .grey300
        case .waitExamination:
            return .dogetherYellow
        case .reject:
            return .dogetherRed
        case .approve:
            return .blue300
        }
    }
    
    var width: CGFloat {
        switch self {
        case .waitCertification:
            return 52
        case .waitExamination:
            return 93
        case .reject:
            return 78
        case .approve:
            return 66
        }
    }
}
