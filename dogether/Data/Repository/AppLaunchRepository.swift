//
//  AppLaunchRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class AppLaunchRepository: AppLaunchProtocol {
    func getIsJoining() async throws -> GetIsJoiningResponse {
        try await GroupsDataSource.shared.getIsJoining()
    }
}
