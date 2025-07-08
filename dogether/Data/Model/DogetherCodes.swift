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

    // MARK: - Failure Code
    case MF0001 = "MF-0001"
    case MF0002 = "MF-0002"
    case AIF0001 = "AIF-0001"
    case CGF0001 = "CGF-0001"
    case CGF0002 = "CGF-0002"
    case CGF0003 = "CGF-0003"
    case CGF0004 = "CGF-0004"
    case CGF0005 = "CGF-0005"
    case CGF0006 = "CGF-0006"
    case CGF0007 = "CGF-0007"
    case CGF0008 = "CGF-0008"
    case CGF0009 = "CGF-0009"
    case CGF0010 = "CGF-0010"
    case CGF0011 = "CGF-0011"
    case DTF0001 = "DTF-0001"
    case DTF0002 = "DTF-0002"
    case DTF0003 = "DTF-0003"
    case DTF0004 = "DTF-0004"
    case DTF0005 = "DTF-0005"
    case DTF0006 = "DTF-0006"
    case DTF0007 = "DTF-0007"
    case DTF0008 = "DTF-0008"
    case DTF0009 = "DTF-0009"
    case DTF0010 = "DTF-0010"
    case TCF0002 = "TCF-0002"
    case TCF0003 = "TCF-0003"
    case TCF0004 = "TCF-0004"
    case TCF0005 = "TCF-0005"
    case NTF0001 = "NTF-0001"

    // MARK: - Exception Code
    case IA001 = "IA-001"

    var description: String {
        switch self {
        // MARK: - Success
        case .CGS0001: return "챌린지 그룹 생성 성공"
        case .CGS0002: return "챌린지 그룹 참여 성공"
        case .CGS0003: return "참여중인 챌린지 그룹 정보 조회 성공"
        case .CGS0004: return "참여중인 챌린지 그룹의 내 누적 활동 통계 조회 성공"
        case .CGS0005: return "참여중인 챌린지 그룹의 팀 전체 누적 활동 통계 조회 성공"
        case .DTS0001: return "데일리 투두 작성 성공"
        case .DTS0002: return "데일리 투두 수행 인증 성공"
        case .DTS0003: return "어제 작성한 데일리 투두 내용 조회 성공"
        case .TCS0001: return "데일리 투두 수행 인증 검사 성공"
        case .TCS0002: return "검사해줘야 하는 데일리 투두 인증 모두 조회 성공"
        case .TCS0003: return "검사해줘야 하는 특정 데일리 투두 인증 id 기반 상세 조회 성공"
        case .NTS0001: return "푸시 알림 토큰 저장 성공"
        case .NTS0002: return "푸시 알림 토큰 삭제 성공"

        // MARK: - Failure
        case .MF0001: return "유효하지 않은 회원 정보"
        case .MF0002: return "존재하지 않는 회원 정보"
        case .AIF0001: return "유효하지 않은 앱 버전 정보 요청"
        case .CGF0001: return "회원이 챌린지 그룹에 속해 있지 않음"
        case .CGF0002: return "챌린지 그룹에 충분한 인원이 없음"
        case .CGF0003: return "현재 진행중인 챌린지 그룹이 아님" // 중복2
        case .CGF0004: return "유효하지 않은 챌린지 그룹 정보" // 중복3
        case .CGF0005: return "챌린지 그룹에 인원이 가득참" // 중복1
        case .CGF0006: return "해당 챌린지 그룹이 존재하지 않음" // 중복3
        case .CGF0007: return "이미 해당 챌린지 그룹에 가입함"
        case .CGF0008: return "챌린지 그룹에 사람이 가득참" // 중복1
        case .CGF0009: return "이미 종료된 챌린지 그룹" // 중복2
        case .CGF0010: return "유효하지 않은 챌린지 그룹 기간"
        case .CGF0011: return "유효하지 않은 챌린지 그룹 시작 날짜"
        case .DTF0001: return "유효하지 않은 데일리 투두"
        case .DTF0002: return "이미 당일 해당 그룹의 투두를 작성함"
        case .DTF0003: return "데일리 투두가 존재하지 않음"
        case .DTF0004: return "유효하지 않은 데일리 투두 상태"
        case .DTF0005: return "데일리 투두 소유자가 아님"
        case .DTF0006: return "유효하지 않은 데일리 투두 상태"
        case .DTF0007: return "유효하지 않은 검사 결과"
        case .DTF0008: return "리뷰 대기중인 데일리 투두가 아님"
        case .DTF0009: return "이미 조회한 데일리 투두 히스토리"
        case .DTF0010: return "데일리 투두 히스토리가 존재하지 않음"
        case .TCF0002: return "유효하지 않은 데일리 투두 인증 혹은 존재하지 않음"
        case .TCF0003: return "해당 데일리 투두 인증의 검사자가 아님"
        case .TCF0004: return "유효하지 않은 데일리 투두 검사자"
        case .TCF0005: return "유효하지 않은 데일리 투두 인증 상태"
        case .NTF0001: return "유효하지 않은 알림 토큰"

        // MARK: - Exception
        case .IA001: return "예기치 못한 문제 발생. 백엔드 팀에 즉시 문의"
        }
    }
}
