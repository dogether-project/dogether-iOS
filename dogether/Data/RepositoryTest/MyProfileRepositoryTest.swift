//
//  MyProfileRepositoryTest.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyProfileRepositoryTest: MyProfileProtocol {
    func getMyProfile() async throws -> ProfileEntity {
        return ProfileEntity(name: "두식", imageUrl: "")
    }
}
