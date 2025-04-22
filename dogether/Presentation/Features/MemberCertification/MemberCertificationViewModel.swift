//
//  MemberCertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import Foundation

final class MemberCertificationViewModel {
    var memberInfo: RankingModel?
    
    // FIXME: API 추가 후 수정
    private(set) var todos: [MemberCertificationInfo] = [
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .done),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .done),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .done),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .done),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 1, content: "신규 기능 개발", thumbnailStatus: .yet),
        MemberCertificationInfo(id: 2, content: "치킨 먹기", certificationContent: "치킨 냠냠", thumbnailStatus: .yet)
    ]
    private(set) var currentIndex: Int = 0
}

extension MemberCertificationViewModel {
    func setCurrentIndex(index: Int) {
        todos[currentIndex].thumbnailStatus = .done
        
        self.currentIndex = index
    }
}
