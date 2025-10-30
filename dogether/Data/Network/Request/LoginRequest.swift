//
//  LoginRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct LoginRequest: Encodable {
    let loginType: LoginTypes
    let providerId: String
    let name: String?
    
    init(loginType: LoginTypes, providerId: String, name: String? = nil) {
        self.loginType = loginType
        self.providerId = providerId
        self.name = name
    }
}
