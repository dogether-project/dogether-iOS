//
//  RemoveNotiTokenRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

struct RemoveNotiTokenRequest: TokenInfo, Encodable {
    let token: String
}
