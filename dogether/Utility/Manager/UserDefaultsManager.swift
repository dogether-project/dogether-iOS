//
//  UserDefaultsManager.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    enum UserDefaultsKey: String {
        case accessToken
        case userFullName
    }
    
    var accessToken: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.accessToken.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.accessToken.rawValue) }
    }
    
    var userFullName: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.userFullName.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.userFullName.rawValue) }
    }    
}
