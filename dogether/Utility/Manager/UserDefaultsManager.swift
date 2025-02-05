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
        case userFullName
        case email
        case userID
    }
    
    var userFullName: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.userFullName.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.userFullName.rawValue) }
    }
    
    var email: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.email.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.email.rawValue) }
    }
    
    var userID: String? {
        get { userDefaults.string(forKey: UserDefaultsKey.userID.rawValue) }
        set { userDefaults.set(newValue, forKey: UserDefaultsKey.userID.rawValue) }
    }
}
