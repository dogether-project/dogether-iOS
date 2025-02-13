//
//  CompleteTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum CompleteTypes {
    case join
    case create
    
    var titleText: String {
        switch self {
        case .join:
            return "그룹에 가입했어요!"
        case .create:
            return "그룹을 생성했어요!"
        }
    }
    
    var subTitleText: String {
        switch self {
        case .join:
            return "지금부터 함께 투두를 달성해볼까요?"
        case .create:
            return "함께할 팀원들에게 초대를 보내보세요"
        }
    }
}
