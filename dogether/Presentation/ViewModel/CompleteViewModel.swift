//
//  CompleteViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/18/25.
//

import Foundation

final class CompleteViewModel {
    var groupType: GroupTypes = .create
    
    var joinCode: String = ""
    var groupInfo: GroupInfo = GroupInfo()
    
    // TODO: 추후 통일
    var joinGroupResponse: JoinGroupResponse?
}
