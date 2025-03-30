//
//  AppLaunchRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/23/25.
//

import Foundation

final class AppLaunchRepositoryTest: AppLaunchProtocol {
    func getIsJoining() async throws -> GetIsJoiningResponse {
//        return GetIsJoiningResponse(isJoining: false)
        return GetIsJoiningResponse(isJoining: true)
    }
}
