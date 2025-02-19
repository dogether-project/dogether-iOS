//
//  GetMySummaryResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetMySummaryResponse: Decodable {
    let totalTodoCount: Int
    /// 인증한 전체 투두 개수
    let totalCertificatedCount: Int
    /// 인정받은 투두 개수
    let totalApprovedCount: Int
    let totalRejectedCount: Int
}
