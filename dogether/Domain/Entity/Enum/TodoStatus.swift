//
//  TodoStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

enum TodoStatus: BaseEntity, Equatable {
    case uncertified                  // 미인증
    case reviewed(ReviewStatus)       // 검사대기/노인정/인정

    // MARK: - 서버 응답 매핑용
    init?(rawValue: String) {
        switch rawValue {
        case "CERTIFY_PENDING":
            self = .uncertified
        case "REVIEW_PENDING":
            self = .reviewed(.pending)
        case "REJECT":
            self = .reviewed(.reject)
        case "APPROVE":
            self = .reviewed(.approve)
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .uncertified:
            return "CERTIFY_PENDING"
        case .reviewed(let status):
            return status.rawValue
        }
    }

    // MARK: - 스타일 속성
    var tag: Int {
        switch self {
        case .uncertified:
            return 0
        case .reviewed(let status):
            switch status {
            case .pending: return 1
            case .reject: return 2
            case .approve: return 3
            }
        }
    }

    var image: UIImage? {
        switch self {
        case .uncertified:
            return nil
        case .reviewed(let status):
            return status.image
        }
    }

    var text: String {
        switch self {
        case .uncertified:
            return "미인증"
        case .reviewed(let status):
            return status.text
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .uncertified:
            return .grey300 // FIXME: 컬러 추가 필요
        case .reviewed(let status):
            return status.backgroundColor
        }
    }

    var reviewStatus: ReviewStatus? {
        switch self {
        case .uncertified:
            return nil
        case .reviewed(let status):
            return status
        }
    }
}

// MARK: - CaseIterable 대체
extension TodoStatus {
    static var allCases: [TodoStatus] {
        [.uncertified, .reviewed(.pending), .reviewed(.reject), .reviewed(.approve)]
    }
}
