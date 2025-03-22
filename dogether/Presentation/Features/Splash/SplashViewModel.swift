//
//  SplashViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class SplashViewModel {
    private let appLaunchUseCase: AppLaunchUseCase
    
    private(set) var destination: BaseViewController?
    
    init() {
        let appLaunchRepository = AppLaunchRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: appLaunchRepository)
    }
    
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
        
        destination = try await appLaunchUseCase.getDestination()
    }
}
