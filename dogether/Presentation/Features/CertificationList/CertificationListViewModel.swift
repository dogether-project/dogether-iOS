//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class CertificationListViewModel {
    var certificationListViewStatus: CertificationListViewStatus = .hasData
    
    var certificationSummary: CertificationSummary = .init(certifiedCount: 5, rejectedCount: 7)
    
    // 인증 목록의 mock 데이터
    private let certifications: [Certification] = [
        Certification(id: UUID(),
                      title: "1회차 검사",
                      completionDate: Date(),
                      status: .waitingForInspection,
                      image: UIImage(named: "sample")!),
        Certification(id: UUID(),
                      title: "2회차 검사",
                      completionDate: Date().addingTimeInterval(-86400),
                      status: .approved,
                      image: UIImage(named: "sample")!),
        Certification(id: UUID(),
                      title: "3회차 검사",
                      completionDate: Date().addingTimeInterval(-172800),
                      status: .rejected,
                      image: UIImage(named: "sample")!),
        Certification(id: UUID(),
                      title: "4회차 검사",
                      completionDate: Date().addingTimeInterval(-172800),
                      status: .approved,
                      image: UIImage(named: "sample")!),
        Certification(id: UUID(),
                      title: "5회차 검사",
                      completionDate: Date().addingTimeInterval(-172800),
                      status: .approved,
                      image: UIImage(named: "sample")!),
        Certification(id: UUID(),
                      title: "6회차 검사",
                      completionDate: Date().addingTimeInterval(-172800),
                      status: .rejected,
                      image: UIImage(named: "sample")!)
    ]
    
    // 인증을 날짤별로 나눈 섹션 데이터
    private(set) var certificationSections: [CertificationSection] = []
}

extension CertificationListViewModel {
    // 필터 처리
    func applyFilter(_ filter: FilterTypes) {
        let filtered: [Certification]
        switch filter {
        case .all:
            filtered = certifications.sorted { $0.completionDate > $1.completionDate }
        case .wait :
            filtered = certifications.filter { $0.status == .waitingForInspection }
        case .approve:
            filtered = certifications.filter { $0.status == .approved }
        case .reject:
            filtered = certifications.filter { $0.status == .rejected }
        default:
            filtered = certifications
        }
        
        generateSections(from: filtered)
    }
    
    private func generateSections(from certifications: [Certification]) {
        let grouped = Dictionary(grouping: certifications) { $0.completionDate.formattedDateString() }
        let sortedKeys = grouped.keys.sorted(by: >)
        certificationSections = sortedKeys.map { CertificationSection(dateString: $0, certifications: grouped[$0] ?? []) }
    }
}

struct CertificationSummary {
    let certifiedCount: Int // 인정
    let rejectedCount: Int  // 노인정
    var achievedCount: Int {
        return certifiedCount + rejectedCount
    }
}

extension CertificationListViewModel {
//    func applySortOption(_ sortOption: String) {
//        switch sortOption {
//        case "그룹 생성일순":
//            certifications.sort { $0.creationDate < $1.creationDate }
//        case "투두 완료일순":
//            certifications.sort { $0.dueDate < $1.dueDate }
//        default:
//            break
//        }
//    }
}
