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
    
    enum BuildMode {
        case debug
        case live
    }
    
    private let defaultBuildMode: BuildMode = .debug
}

extension DIManager {
    func getAppLaunchRepository(buildMode: BuildMode? = nil) -> AppLaunchProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AppLaunchRepositoryTest()
        case .live:
            return AppLaunchRepository()
        }
    }
    
    func getAuthRepository(buildMode: BuildMode? = nil) -> AuthProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return AuthRepositoryTest()
        case .live:
            return AuthRepository()
        }
    }
    
    func getMainRepository(buildMode: BuildMode? = nil) -> MainProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return MainRepositoryTest()
        case .live:
            return MainRepository()
        }
    }
    
    func getGroupRepository(buildMode: BuildMode? = nil) -> GroupProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return GroupRepositoryTest()
        case .live:
            return GroupRepository()
        }
    }
    
    func getTodoRepository(buildMode: BuildMode? = nil) -> TodoProtocol {
        switch buildMode ?? defaultBuildMode {
        case .debug:
            return TodoRepositoryTest()
        case .live:
            return TodoRepository()
        }
    }
}
