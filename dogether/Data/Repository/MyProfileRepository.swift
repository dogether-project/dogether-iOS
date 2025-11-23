//
//  MyProfileRepository.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyProfileRepository: MyProfileProtocol {
    private let dataSource: MyProfileDataSource
    
    init(dataSource: MyProfileDataSource = .shared) {
        self.dataSource = dataSource
    }
    
    func getMyProfile() async throws -> ProfileEntity {
        let response = try await dataSource.getMyProfile()
        return ProfileEntity(
            name: response.name,
            imageUrl: response.profileImageUrl
        )
    }
}
