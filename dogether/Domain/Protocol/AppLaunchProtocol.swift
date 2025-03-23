//
//  AppLaunchProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

protocol AppLaunchProtocol {
    func getIsJoining() async throws -> GetIsJoiningResponse
}
