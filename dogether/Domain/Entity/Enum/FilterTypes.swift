//
//  FilterTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

enum FilterTypes: BaseEntity, Equatable {
    case all
    case status(ReviewStatus)

    // MARK: - 스타일 속성
    var tag: Int {
        switch self {
        case .all:
            return 0
        case .status(let status):
            switch status {
            case .pending: return 1
            case .reject: return 2
            case .approve: return 3
            }
        }
    }

    var text: String {
        switch self {
        case .all:
            return "전체"
        case .status(let status):
            return status.text
        }
    }

    var image: UIImage? {
        switch self {
        case .all:
            return nil
        case .status(let status):
            return status.image
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .all:
            return Color.Background.primary
        case .status(let status):
            return status.backgroundColor
        }
    }

    var emptyTitle: String {
        switch self {
        case .all:
            return ""
        case .status(let status):
            switch status {
            case .pending:
                return "검사 대기 중인 투두가 없어요"
            case .reject:
                return "노인정받은 투두가 없어요"
            case .approve:
                return "인정받은 투두가 없어요"
            }
        }
    }

    var reviewStatus: ReviewStatus? {
        switch self {
        case .all:
            return nil
        case .status(let status):
            return status
        }
    }
}

// MARK: - CaseIterable 대체
extension FilterTypes {
    static var allCases: [FilterTypes] {
        [.all, .status(.pending), .status(.reject), .status(.approve)]
    }
}

// MARK: - 서버 응답 매핑용
extension FilterTypes {
    init?(rawValue: String) {
        switch rawValue {
        case "전체":
            self = .all
        case "검사 대기":
            self = .status(.pending)
        case "노인정":
            self = .status(.reject)
        case "인정":
            self = .status(.approve)
        default:
            return nil
        }
    }

    var rawValue: String {
        return text
    }

    init?(statusString: String) {
        switch statusString.uppercased() {
        case "REVIEW_PENDING":
            self = .status(.pending)
        case "REJECT":
            self = .status(.reject)
        case "APPROVE":
            self = .status(.approve)
        default:
            return nil
        }
    }
}
