//
//  MyPageViewModel.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import RxRelay

final class MyPageViewModel {
    private let myProfileUseCase: MyProfileUseCase
    
    private(set) var profileViewDatas = BehaviorRelay<ProfileViewDatas>(value: ProfileViewDatas())
    private(set) var statsButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(value: DogetherButtonViewDatas())
    
    init() {
        let myProfileRepository = DIManager.shared.getMyProfileRepository()
        self.myProfileUseCase = MyProfileUseCase(repository: myProfileRepository)
    }
}

extension MyPageViewModel {
    func loadProfileView() async throws {
        try await getMyProfile()
    }
    
    func getMyProfile() async throws {
        let profile = try await myProfileUseCase.getMyProfile()
        
        profileViewDatas.update {
            $0.name = profile.name
            $0.imageUrl = profile.imageUrl
        }
    }
}
