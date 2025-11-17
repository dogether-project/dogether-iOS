//
//  MyPageViewModel.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyPageViewModel {
    private let myProfileUseCase: MyProfileUseCase
    
    private(set) var profileEntity = BehaviorRelay<ProfileEntity>(value: ProfileEntity())
    
    init() {
        let myProfileRepository = DIManager.shared.getMyProfileRepository()
        self.myProfileUseCase = MyProfileUseCase(repository: myProfileRepository)
    }
}

extension MyPageViewModel {
    func loadProfileView() async throws {
        try await getProfile()
    }
    
    func getProfile() async throws {
        let profile = try await myProfileUseCase.getProfile()
        
        profileEntity.update {
            $0.name = profile.name
            $0.imageUrl = profile.imageUrl
        }
    }
}
