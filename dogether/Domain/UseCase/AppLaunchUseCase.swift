//
//  AppLaunchUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import UIKit

final class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
    
    func launchApp() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)

            let destination = try await getDestination()
            await MainActor.run { NavigationManager.shared.setNavigationController(destination) }
        }
    }
    
    func getDestination() async throws -> UIViewController {
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
