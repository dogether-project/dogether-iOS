//
//  CertificationListUseCase.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListUseCase {
    private let repository: CertificationListProtocol
    
    init(repository: CertificationListProtocol) {
        self.repository = repository
    }
    
    func fetchSortedList(option: CertificationSortOption, page: Int) async throws -> CertificationListResult {
        let result: CertificationListResult
        
        switch option {
        case .todoCompletionDate:
            result = try await repository.fetchByTodoCompletionDate(page: page)
            return result
        case .groupCreationDate:
            result = try await repository.fetchByGroupCreationDate(page: page)
            return result
        }
    }
}
