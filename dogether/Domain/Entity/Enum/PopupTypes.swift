//
//  PopupTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

enum PopupTypes {
    case alert
    case certification
    case certificationInfo
    case rejectReason
}

enum AlertTypes {
    case leaveGroup
    case logout
    case withdraw
    case saveTodo
    
    var title: String {
        switch self {
        case .leaveGroup:
            return "현재 그룹을 탈퇴하시겠어요?"
        case .logout:
            return "로그아웃 하시겠어요?"
        case .withdraw:
            return "정말 회원탈퇴를 하시겠어요?"
        case .saveTodo:
            return "투두를 저장하시겠습니까?"
        }
    }
    
    var message: String? {
        switch self {
        case .leaveGroup:
            return "그룹을 탈퇴하면 그룹 내 모든 데이터가\n삭제되어 복구할 수 없어요."
        case .withdraw:
            return "탈퇴하면 모든 데이터가 삭제되며\n복구할 수 없어요."
        case .saveTodo:
            return "한 번 저장한 투두는 수정과 삭제가 불가능합니다"
        default:
            return nil
        }
    }
    
    var buttonText: String {
        switch self {
        case .leaveGroup, .withdraw:
            return "탈퇴하기"
        case .logout:
            return "로그아웃"
        case .saveTodo:
            return "저장하기"
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .leaveGroup, .withdraw:
            return .dogetherRed
        case .logout, .saveTodo:
            return .blue300
        }
    }
}
