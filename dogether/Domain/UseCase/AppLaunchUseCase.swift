//
//  AppLaunchUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation
import UIKit

final class AppLaunchUseCase {
    private let repository: AppLaunchInterface
    
    init(repository: AppLaunchInterface) {
        self.repository = repository
    }
    
    func getDestination() async throws -> UIViewController {
        let needLogin = UserDefaultsManager.shared.accessToken == nil
        
        if needLogin {
            return await OnboardingViewController()
        }
        
        let isJoining = try await repository.getIsJoining()
        
        if isJoining {
            return await MainViewController()
        } else {
            return await StartViewController()
        }
    }
}
