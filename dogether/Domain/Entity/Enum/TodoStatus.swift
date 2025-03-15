//
//  TodoStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

enum TodoStatus: String, CaseIterable {
    case waitCertificattion = "CERTIFY_PENDING"
    case waitExamination = "REVIEW_PENDING"
    case reject = "REJECT"
    case approve = "APPROVE"
    
    var tag: Int {
        switch self {
        case .waitCertificattion:
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
        case .waitCertificattion:
            return nil
        case .waitExamination:
            return .wait
        case .reject:
            return .reject
        case .approve:
            return .approve
        }
    }
    
    var contentColor: UIColor {
        switch self {
        case .waitCertificattion:
            return .grey50
        default:
            return .grey300
        }
    }
    
    var buttonText: String {
        switch self {
        case .waitCertificattion:
            return "인증하기"
        default:
            return "인증완료"
        }
    }
    
    var buttonTextColor: UIColor {
        switch self {
        case .waitCertificattion:
            return .grey900
        default:
            return .grey400
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .waitCertificattion:
            return .blue300
        default:
            return .grey800
        }
    }
}
