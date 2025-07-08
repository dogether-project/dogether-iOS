//
//  ErrorConfigProvider.swift
//  dogether
//
//  Created by yujaehong on 6/23/25.
//

import UIKit

enum ErrorConfigProvider {
    // MARK: - 두게더 에러
    static func config(for code: DogetherCodes) -> ErrorTemplateConfig {
        switch code {
//        case .CGE0004:
//            return ErrorTemplateConfig(
//                image: UIImage(named: "sweatDosik")!,
//                title: "그룹 생성에 실패했어요.",
//                subtitle: nil,
//                leftButtonTitle: "뒤로가기",
//                rightButtonTitle: nil,
//                leftActionType: .goBack,
//                rightActionType: nil
//            )
        case .CGF0007:
            return ErrorTemplateConfig(
                image: UIImage(named: "sweatDosik")!,
                title: "이미 참여한 그룹이에요.",
                subtitle: "해당 그룹은 다시 참여하실 수 없어요.",
                leftButtonTitle: "홈으로",
                rightButtonTitle: "새로운 그룹 생성",
                leftActionType: .goHome,
                rightActionType: .goGroupCreate
            )
        case .CGF0008:
            return ErrorTemplateConfig(
                image: UIImage(named: "sweatDosik")!,
                title: "그룹 인원이 가득 찼어요.",
                subtitle: "다른 그룹에 참여하거나 새로 만들어주세요.",
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: "새로운 그룹 생성",
                leftActionType: .goBack,
                rightActionType: .goGroupCreate
            )
        case .CGF0003, .CGF0004, .CGF0006, .CGF0009:
            return ErrorTemplateConfig(
                image: UIImage(named: "sweatDosik")!,
                title: "참여할 수 없는 그룹이에요.",
                subtitle: "종료되었거나 유효하지 않은 그룹이에요.",
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: "새로운 그룹 생성",
                leftActionType: .goBack,
                rightActionType: .goGroupCreate
            )
        default:
            return ErrorTemplateConfig(
                image: UIImage(named: "iceDosik")!,
                title: "예기치 않은 문제가 발생했어요.",
                subtitle: nil,
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: nil,
                leftActionType: .goBack,
                rightActionType: nil
            )
        }
    }
    
    // MARK: - 네트워크 에러
    static func config(for error: NetworkError) -> ErrorTemplateConfig {
           switch error {
           case .serverError, .unknown:
               return ErrorTemplateConfig(
                image: UIImage(named: "headacheDosik")!,
                title: "네트워크 연결이 불안정해요.",
                subtitle: "연결 상태를 확인한 후 다시 시도해주세요.",
                leftButtonTitle: "다시 시도",
                rightButtonTitle: nil,
                leftActionType: .retry,
                rightActionType: nil
               )
           case .badRequest, .invalidURL, .unauthorized:
               return ErrorTemplateConfig(
                image: UIImage(named: "iceDosik")!,
                title: "일시적인 문제가 발생했어요.",
                subtitle: "잠시 후 다시 시도해주세요.",
                leftButtonTitle: "홈으로 돌아가기",
                rightButtonTitle: nil,
                leftActionType: .goHome,
                rightActionType: nil
               )
           case .noData, .notFound, .decodingFailed:
               return ErrorTemplateConfig(
                image: UIImage(named: "failDosik")!,
                title: "데이터를 불러오는 데 실패했어요.",
                subtitle: "잠시 후 다시 시도해주세요.",
                leftButtonTitle: "다시 시도",
                rightButtonTitle: nil,
                leftActionType: .retry,
                rightActionType: nil
               )
           default:
               return ErrorTemplateConfig(
                image: UIImage(named: "iceDosik")!,
                title: "예기치 않은 문제가 발생했어요.",
                subtitle: nil,
                leftButtonTitle: "뒤로 가기",
                rightButtonTitle: nil,
                leftActionType: .goBack,
                rightActionType: nil
               )
           }
    }
}
