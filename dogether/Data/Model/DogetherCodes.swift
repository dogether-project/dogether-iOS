//
//  DogetherCodes.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum DogetherCodes: String, Decodable {
    // MARK: - Success Code
    case CGS0001 = "CGS-0001"
    case CGS0002 = "CGS-0002"
    case CGS0003 = "CGS-0003"
    case CGS0004 = "CGS-0004"
    case CGS0005 = "CGS-0005"
    case DTS0001 = "DTS-0001"
    case DTS0002 = "DTS-0002"
    case DTS0003 = "DTS-0003"
    case TCS0001 = "TCS-0001"
    case TCS0002 = "TCS-0002"
    case TCS0003 = "TCS-0003"
    case NTS0001 = "NTS-0001"
    case NTS0002 = "NTS-0002"
    
    // MARK: - Exception Code
    case IA001 = "IA-001"
    
    var description: String {
        switch self {
        case .CGS0001:
            "챌린지 그룹 생성 성공"
        case .CGS0002:
            "챌린지 그룹 참여 성공"
        case .CGS0003:
            "참여중인 챌린지 그룹 정보 조회 성공"
        case .CGS0004:
            "참여중인 챌린지 그룹의 내 누적 활동 통계 조회 성공"
        case .CGS0005:
            "참여중인 챌린지 그룹의 팀 전체 누적 활동 통계 조회 성공"
        case .DTS0001:
            "데일리 투두 작성 성공"
        case .DTS0002:
            "데일리 투두 수행 인증 성공"
        case .DTS0003:
            "어제 작성한 데일리 투두 내용 조회 성공"
        case .TCS0001:
            "데일리 투두 수행 인증 검사 성공"
        case .TCS0002:
            "검사해줘야 하는 데일리 투두 인증 모두 조회 성공"
        case .TCS0003:
            "검사해줘야 하는 특정 데일리 투두 인증 id 기반 상세 조회 성공"
        case .NTS0001:
            "푸시 알림 토큰 저장 성공"
        case .NTS0002:
            "푸시 알림 토큰 삭제 성공"
            
        case .IA001:
            "예기치 못한 문제 발생. 백엔드 팀에 즉시 문의"
        }
    }
}
