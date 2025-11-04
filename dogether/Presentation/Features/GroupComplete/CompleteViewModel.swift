//
//  CompleteViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/18/25.
//

import RxRelay

final class CompleteViewModel {
    private(set) var completeViewDatas = BehaviorRelay<CompleteViewDatas>(value: CompleteViewDatas())
}

extension CompleteViewModel {
    func setDatas(_ datas: CompleteViewDatas) {
        completeViewDatas.accept(datas)
    }

    func shareGroupCode() -> [Any] {
        let data = completeViewDatas.value
        return SystemManager.inviteGroup(
            groupName: data.groupInfo.name,
            joinCode: data.joinCode
        )
    }
}
