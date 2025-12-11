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
    
    func fetchSortedList(option: SortOptions, page: Int) async throws -> CertificationListResult {
        let pageString = String(page)
        switch option {
        case .todoCompletionDate:
            return try await repository.fetchByTodoCompletionDate(sort: option.sortString, page: pageString)
        case .groupCreationDate:
            return try await repository.fetchByGroupCreationDate(sort: option.sortString, page: pageString)
        }
    }
}
