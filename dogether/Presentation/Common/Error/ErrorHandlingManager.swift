//
//  ErrorHandlingManager.swift
//  dogether
//
//  Created by yujaehong on 7/12/25.
//

import UIKit

final class ErrorHandlingManager {
    // MARK: - 에러화면으로 전환
    static func handle(
        error: NetworkError,
        presentingViewController viewController: UIViewController, // 에러 화면을 띄울 기준이 되는 UIViewController
        coordinator: NavigationCoordinator?,
        retryHandler: (() -> Void)? = nil
    ) {
        let config: ErrorTemplateConfig = {
            switch error {
            case .dogetherError(let code, _):
                return configForCode(code: code)
            default:
                return configForError(error: error)
            }
        }()
        
        let errorVC = ErrorViewController(config: config)
        
        errorVC.leftButtonAction = {
            handleLeftAction(config.leftActionType,
                             from: viewController,
                             coordinator: coordinator,
                             retryHandler: retryHandler)
        }
        
        errorVC.rightButtonAction = {
            guard let rightType = config.rightActionType else { return }
            handleRightAction(rightType,
                              from: viewController,
                              coordinator: coordinator,
                              retryHandler: retryHandler)
        }
        
        coordinator?.presentViewController(errorVC, animated: false)
    }
    
    // MARK: - 에러 뷰 삽입
    static func embedErrorView(
        in viewController: UIViewController,
        under navigationView: UIView,
        error: NetworkError,
        retryHandler: (() -> Void)? = nil
    ) -> ErrorView {
        let config = configForError(error: error)
        let errorView = ErrorView(config: config)
        
        viewController.view.addSubview(errorView)
        errorView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        errorView.leftButtonAction = {
            errorView.removeFromSuperview()
            retryHandler?()
        }
        
        return errorView
    }
}

// MARK: - 버튼 액션 핸들링
extension ErrorHandlingManager {
    private static func handleLeftAction(
        _ type: ErrorActionType,
        from viewController: UIViewController,
        coordinator: NavigationCoordinator?,
        retryHandler: (() -> Void)?
    ) {
        switch type {
        case .goBack:
            coordinator?.popViewController()
        case .goHome:
            coordinator?.setNavigationController(MainViewController())
        case .retry:
            retryHandler?()
            //        case .goGroupCreate:
            //            coordinator.pushViewController(GroupCreateViewController())
        default:
            break
        }
    }
    
    private static func handleRightAction(
        _ type: ErrorActionType,
        from viewController: UIViewController,
        coordinator: NavigationCoordinator?,
        retryHandler: (() -> Void)?
    ) {
        switch type {
        case .goBack:
            coordinator?.popViewController()
        case .goHome:
            coordinator?.setNavigationController(MainViewController())
        case .retry:
            retryHandler?()
        case .goGroupCreate:
            coordinator?.pushViewController(GroupCreateViewController())
            //        case .none:
            //            break
        default:
            break
        }
    }
}

// MARK: - 에러 설정값 매핑
extension ErrorHandlingManager {
    private static func configForCode(code: DogetherCodes) -> ErrorTemplateConfig {
        switch code {
        case .CGF0007:
            return ErrorTemplateConfig(
                image: .sweatDosik,
                title: "이미 참여한 그룹이에요.",
                subtitle: "해당 그룹은 다시 참여하실 수 없어요.",
                leftButtonTitle: "홈으로",
                rightButtonTitle: "새로운 그룹 생성",
                leftActionType: .goHome,
                rightActionType: .goGroupCreate
            )
        case .CGF0008:
            return ErrorTemplateConfig(
                image: .sweatDosik,
                title: "그룹 인원이 가득 찼어요.",
                subtitle: "다른 그룹에 참여하거나 새로 만들어주세요.",
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: "새로운 그룹 생성",
                leftActionType: .goBack,
                rightActionType: .goGroupCreate
            )
        default:
            return ErrorTemplateConfig(
                image: .iceDosik,
                title: "예기치 않은 문제가 발생했어요.",
                subtitle: nil,
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: nil,
                leftActionType: .goBack,
                rightActionType: nil
            )
        }
    }
    
    private static func configForError(error: NetworkError) -> ErrorTemplateConfig {
        switch error {
        case .serverError, .unknown:
            return ErrorTemplateConfig(
                image: .headacheDosik,
                title: "네트워크 연결이 불안정해요.",
                subtitle: "연결 상태를 확인한 후 다시 시도해주세요.",
                leftButtonTitle: "다시 시도",
                rightButtonTitle: nil,
                leftActionType: .retry,
                rightActionType: nil
            )
        case .badRequest:
            return ErrorTemplateConfig(
                image: .iceDosik,
                title: "일시적인 문제가 발생했어요.",
                subtitle: "잠시 후 다시 시도해주세요.",
                leftButtonTitle: "홈으로 돌아가기",
                rightButtonTitle: nil,
                leftActionType: .goHome,
                rightActionType: nil
            )
        default:
            return ErrorTemplateConfig(
                image: .iceDosik,
                title: "예기치 않은 문제가 발생했어요.",
                subtitle: nil,
                leftButtonTitle: "뒤로가기",
                rightButtonTitle: nil,
                leftActionType: .goBack,
                rightActionType: nil
            )
        }
    }
}
