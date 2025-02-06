//
//  AppleLoginResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct AppleLoginResponse: Decodable {
    let name: String
    let accessToken: String
}
