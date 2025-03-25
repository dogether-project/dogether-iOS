//
//  AppLaunchRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class AppLaunchRepository: AppLaunchProtocol {
    private let grouspDataSource: GroupsDataSource
    
    init(grouspDataSource: GroupsDataSource = .shared) {
        self.grouspDataSource = grouspDataSource
    }
    
    func getIsJoining() async throws -> GetIsJoiningResponse {
        try await grouspDataSource.getIsJoining()
    }
}
