//
//  SplashViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

import RxRelay

final class SplashViewModel {
    private let appLaunchUseCase: AppLaunchUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var needUpdate = BehaviorRelay<Bool>(value: false)
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let appInfoRepository = DIManager.shared.getAppInfoRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appInfoRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
    
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
    }
    
    func checkUpdate() async throws {
        needUpdate.accept(try await appLaunchUseCase.checkUpdate())
    }
    
    func getDestination() async throws -> BaseViewController {
        if UserDefaultsManager.shared.accessToken == nil { return await OnboardingViewController() }
        
        let isParticipating = try await groupUseCase.getIsParticipating()
        let destination = try await appLaunchUseCase.getDestination(isParticipating: isParticipating)
        return destination
    }
}
