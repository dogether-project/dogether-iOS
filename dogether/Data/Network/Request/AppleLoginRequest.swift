//
//  AppleLoginRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct AppleLoginRequest: Encodable {
    let name: String?
    let idToken: String
    
    init(name: String? = nil, idToken: String) {
        self.name = name
        self.idToken = idToken
    }
}
