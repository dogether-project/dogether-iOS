//
//  SplashViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class SplashViewModel {
    private let appLaunchUseCase: AppLaunchUseCase
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
    }
    
    func loadApp() {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            let destination = try await appLaunchUseCase.getDestination()
            NavigationManager.shared.setNavigationController(destination)
        }
    }
}
