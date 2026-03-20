//
//  ReviewStatus.swift
//  dogether
//
//  Created by yujaehong on 2/2/26.
//

import UIKit

enum ReviewStatus: String, CaseIterable, BaseEntity {
    case pending = "REVIEW_PENDING"   // 검사 대기
    case reject = "REJECT"            // 노인정
    case approve = "APPROVE"          // 인정

    var text: String {
        switch self {
        case .pending:
            return "검사 대기"
        case .reject:
            return "노인정"
        case .approve:
            return "인정"
        }
    }

    var image: UIImage? {
        switch self {
        case .pending:
            return .wait
        case .reject:
            return .reject
        case .approve:
            return .approve
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .pending:
            return .dogetherYellow // FIXME: 컬러 추가 필요
        case .reject:
            return .dogetherRed // FIXME: 컬러 추가 필요
        case .approve:
            return Color.Background.primary
        }
    }
}
