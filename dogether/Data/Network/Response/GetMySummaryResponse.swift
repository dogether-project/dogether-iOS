//
//  GetMySummaryResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

/// 참여중인 그룹의 내 누적 활동 통계 조회
struct GetMySummaryResponse: TotalCount, Decodable {
    /// 작성한 전체 투두 개수
    let totalTodoCount: Int
    /// 인증한 전체 투두 개수
    let totalCertificatedCount: Int
    /// 인정받은 투두 개수
    let totalApprovedCount: Int
    /// 노인정 투두 개수
    let totalRejectedCount: Int
}
