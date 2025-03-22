//
//  AppLaunchUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
    
    func launchApp() async throws {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
    func getDestination() async throws -> BaseViewController {
        let needLogin = UserDefaultsManager.shared.accessToken == nil
        if needLogin { return await OnboardingViewController()}
        
        let response = try await repository.getIsJoining()
        if response.isJoining {
            return await MainViewController()
        } else {
            return await StartViewController()
        }
    }
}
