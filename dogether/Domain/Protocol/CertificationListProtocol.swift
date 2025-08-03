//
//  CertificationListProtocol.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

protocol CertificationListProtocol {
    func fetchByTodoCompletionDate(page: Int) async throws -> CertificationListResult
    func fetchByGroupCreationDate(page: Int) async throws -> CertificationListResult
}
