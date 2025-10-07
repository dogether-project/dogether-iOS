//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import RxSwift
import RxCocoa

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        pages = [splashPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func bindViewModel() {
        viewModel.needUpdate
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(UpdateViewController())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.needLogin
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(OnboardingViewController())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.needParticipating
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(StartViewController())
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SplashViewController {
    private func onAppear() {
        Task {
            // MARK: SplashView의 경우 API 호출에 순서가 정해져있어 동기 호출 방식 보다는 로딩바를 임시로 하나 더 추가해 제어함
            LoadingManager.shared.showLoading()
            defer { LoadingManager.shared.hideLoading() }
            
            do {
                try await viewModel.launchApp()
                
                try await viewModel.checkUpdate()
                if viewModel.needUpdate.value { return }
                
                try await viewModel.checkLogin()
                if viewModel.needLogin.value { return }
                
                try await viewModel.checkParticipating()
                if viewModel.needParticipating.value { return }
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    coordinator?.setNavigationController(MainViewController())
                }
            } catch {
                await MainActor.run {
                    ErrorHandlingManager.presentErrorView(
                        error: error,
                        presentingViewController: self,
                        coordinator: coordinator,
                        retryHandler: { [weak self] in
                            guard let self else { return }
                            onAppear()
                        },
                        showCloseButton: false
                    )
                }
            }
        }
    }
}
