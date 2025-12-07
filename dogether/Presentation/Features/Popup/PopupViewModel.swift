//
//  PopupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import UIKit

import RxRelay

final class PopupViewModel {
    private let challengeGrouopUseCase: ChallengeGroupUseCase
    
    private(set) var alertPopupViewDatas = BehaviorRelay<AlertPopupViewDatas>(value: AlertPopupViewDatas())
    
    private(set) var stringContent: String?
    
    var popupType: PopupTypes?
    var alertType: AlertTypes?
    var todoInfo: TodoEntity?
    
    init() {
        let challengeGroupRepository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGrouopUseCase = ChallengeGroupUseCase(repository: challengeGroupRepository)
    }
}

extension PopupViewModel {
    func setStringContent(_ text: String) {
        stringContent = text
    }
}
