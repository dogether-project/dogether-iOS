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
        let groupRepository = DIManager.shared.getGroupRepository()
        self.appLaunchUseCase = AppLaunchUseCase(repository: groupRepository)
    }
    
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
        
        destination = try await appLaunchUseCase.getDestination()
    }
}
