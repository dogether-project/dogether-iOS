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
    
    func launchApp() {
        appLaunchUseCase.launchApp()
    }
}
