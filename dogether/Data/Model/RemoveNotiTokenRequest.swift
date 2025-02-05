//
//  RemoveNotiTokenRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

// TODO: 추후 수정
struct RemoveNotiTokenRequest: TokenInfo, Encodable {
    let token: String = "kelly-token-value"
}
