//
//  MyPageViewModel.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation
import RxRelay

final class MyPageViewModel {
    private let myProfileUseCase: MyProfileUseCase
    
    private(set) var profileViewDatas = BehaviorRelay<ProfileViewDatas>(value: ProfileViewDatas())
    
    init() {
        let myProfileRepository = DIManager.shared.getMyProfileRepository()
        self.myProfileUseCase = MyProfileUseCase(repository: myProfileRepository)
    }
}

extension MyPageViewModel {
    func loadProfileView() async throws {
        try await getProfileInfo()
    }
    
    private func getProfileInfo() async throws {
        let profile = try await myProfileUseCase.getProfileInfo()

        profileViewDatas.update {
            $0.name = profile.name
            $0.imageUrl = profile.imageUrl
        }
    }
}
