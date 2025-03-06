//
//  AppLaunchInterface.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

protocol AppLaunchInterface {
    func getIsJoining() async throws -> GetIsJoiningResponse
}
