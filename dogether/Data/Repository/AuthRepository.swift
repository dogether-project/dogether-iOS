//
//  AuthRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class AuthRepository: AuthProtocol {
    private let authDataSource: AuthDataSource
    private let notificationDataSource: NotificationDataSource
    
    init(
        authDataSource: AuthDataSource = .shared,
        notificationDataSou: NotificationDataSource = .shared
    ) {
        self.authDataSource = authDataSource
        self.notificationDataSource = notificationDataSou
    }
    
    func login(loginRequest: LoginRequest) async throws -> LoginResponse {
        try await authDataSource.login(loginRequest: loginRequest)
    }
    
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws {
        try await notificationDataSource.saveNotiToken(saveNotiTokenRequest: saveNotiTokenRequest)
    }
    
    func withdraw(loginType: LoginTypes, authorizationCode: String?) async throws {
        let withdrawRequest = WithdrawRequest(loginType: loginType.rawValue, authorizationCode: authorizationCode)
        try await authDataSource.withdraw(withdrawRequest: withdrawRequest)
    }
}

