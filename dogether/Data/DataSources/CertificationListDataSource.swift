//
//  CertificationListDataSource.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListDataSource {
    static let shared = CertificationListDataSource()
    
    private init() {}
    
    func fetchByTodoCompletionDate(page: Int) async throws -> CertificationDailyListResponse {
        try await NetworkManager.shared.request(CertificationListRouter.getMyActivity(sort: .todoCompletedAt, page: page))
        
    }
    
    func fetchByGroupCreationDate(page: Int) async throws -> CertificationGroupListResponse {
        try await NetworkManager.shared.request(CertificationListRouter.getMyActivity(sort: .groupCreatedAt, page: page))
    }
}
