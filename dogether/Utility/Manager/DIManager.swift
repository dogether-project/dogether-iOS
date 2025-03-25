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
    
    private let defualtBuildMode: BuildMode = .debug
}

extension DIManager {
    func getAppLaunchRepository(buildMode: BuildMode? = nil) -> AppLaunchProtocol {
        switch buildMode ?? defualtBuildMode {
        case .debug:
            return AppLaunchRepositoryTest()
        case .live:
            return AppLaunchRepository()
        }
    }
    
    func getAuthRepository(buildMode: BuildMode? = nil) -> AuthProtocol {
        switch buildMode ?? defualtBuildMode {
        case .debug:
            return AuthRepositoryTest()
        case .live:
            return AuthRepository()
        }
    }
    
    func getMainRepository(buildMode: BuildMode? = nil) -> MainProtocol {
        switch buildMode ?? defualtBuildMode {
        case .debug:
            return MainRepositoryTest()
        case .live:
            return MainRepository()
        }
    }
    
    func getGroupCreateRepository(buildMode: BuildMode? = nil) -> GroupCreateProtocol {
        switch buildMode ?? defualtBuildMode {
        case .debug:
            return GroupCreateRepositoryTest()
        case .live:
            return GroupCreateRepository()
        }
    }
}
