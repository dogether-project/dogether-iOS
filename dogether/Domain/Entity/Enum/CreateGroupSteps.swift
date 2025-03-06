//
//  CreateGroupSteps.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum CreateGroupSteps: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    var description: String {
        switch self {
        case .one:
            return "어떤 그룹을 만들까요?"
        case .two:
            return "최대 몇 개의 투두를 설정할까요?"
        case .three:
            return "어떤 일정으로 진행할까요?"
        case .four:
            return "입력한 그룹 정보를 확인해주세요"
        }
    }
}
