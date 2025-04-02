//
//  DIManager.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class DIManager {
    static let shared = DIManager()
    
    private init() { }
    
    enum BuildModes {
        case debug
        case live
    }
    
    private let defaultBuildMode: BuildModes = .debug
}

extension DIManager {
    func getAppLaunchRepository(buildMode: BuildModes? = nil) -> AppLaunchProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AppLaunchRepositoryTest()
        case .live:
            return AppLaunchRepository()
        }
    }
    
    func getAuthRepository(buildMode: BuildModes? = nil) -> AuthProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AuthRepositoryTest()
        case .live:
            return AuthRepository()
        }
    }
    
    func getMainRepository(buildMode: BuildModes? = nil) -> MainProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return MainRepositoryTest()
        case .live:
            return MainRepository()
        }
    }
    
    func getGroupRepository(buildMode: BuildModes? = nil) -> GroupProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return GroupRepositoryTest()
        case .live:
            return GroupRepository()
        }
    }
    
    func getTodoRepository(buildMode: BuildModes? = nil) -> TodoProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return TodoRepositoryTest()
        case .live:
            return TodoRepository()
        }
    }
    
    func getPopupRepository(buildMode: BuildModes? = nil) -> PopupProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return PopupRepositoryTest()
        case .live:
            return PopupRepository()
        }
    }
}
