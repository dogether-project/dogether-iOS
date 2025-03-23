//
//  GroupCreateUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupCreateUseCase {
    private let repository: GroupCreateProtocol
    
    init(repository: GroupCreateProtocol) {
        self.repository = repository
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> String {
        let response = try await repository.createGroup(createGroupRequest: createGroupRequest)
        return response.joinCode
    }
}
