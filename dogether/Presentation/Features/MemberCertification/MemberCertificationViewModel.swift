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
    private(set) var todos: [TodoInfo] = [
        TodoInfo(id: 1, content: "신규 기능 개발", status: "CERTIFY_PENDING"),
        TodoInfo(id: 2, content: "치킨 먹기", status: "REVIEW_PENDING", certificationContent: "치킨 냠냠")
    ]
    private(set) var currentIndex: Int = 0
}
