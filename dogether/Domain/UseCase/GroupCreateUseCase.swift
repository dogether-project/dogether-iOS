//
//  GroupCreateUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupCreateUseCase {
    private let repository: GroupCreateInterface
    
    init(repository: GroupCreateInterface) {
        self.repository = repository
    }
    
    func navigateToCompleteView(createGroupRequest: CreateGroupRequest) {
        Task {
            let joinCode = try await getJoinCode(createGroupRequest: createGroupRequest)
            await MainActor.run {
                let completeViewController = CompleteViewController(type: .create)
                completeViewController.viewModel.joinCode = joinCode
                NavigationManager.shared.setNavigationController(completeViewController)
            }
        }
    }
    
    func getJoinCode(createGroupRequest: CreateGroupRequest) async throws -> String {
        let response = try await repository.createGroup(createGroupRequest: createGroupRequest)
        return response.joinCode
    }
}
