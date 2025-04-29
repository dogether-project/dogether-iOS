//
//  CertificationListViewStatus.swift
//  dogether
//
//  Created by yujaehong on 4/28/25.
//

import UIKit

enum CertificationListViewStatus {
    case empty
    case hasData
}

// 인증 상태 정의
enum CertificationStatus {
    case waitingForInspection
    case approved
    case rejected
    
    var filterType: FilterTypes {
        switch self {
        case .approved:
            return .approve
        case .waitingForInspection:
            return .wait
        case .rejected:
            return .reject
        }
    }
}

// Certification 모델
struct Certification {
    let id: UUID
    let title: String
    let completionDate: Date
    let status: CertificationStatus
//    let iamgeUrl: String
    let image: UIImage
    
}

// 날짜별로 섹션을 나누기 위한 모델 정의
struct CertificationSection {
    let dateString: String
    let certifications: [Certification]
}

// 날짜 형식 함수 추가
extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        return formatter.string(from: self)
    }
}
