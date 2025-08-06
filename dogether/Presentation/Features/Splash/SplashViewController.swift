//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
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
                    coordinator?.setNavigationController(UpdateViewController())    // TODO: animated 고민
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
        
        viewModel.isParticipating
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isParticipating in
                guard let self else { return }
                if !isParticipating {
                    coordinator?.setNavigationController(StartViewController())
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [splashPage].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        splashPage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SplashViewController {
    private func onAppear() {
        Task {
            do {
                try await viewModel.launchApp()
                
                try await viewModel.checkUpdate()
                if viewModel.needUpdate.value { return }
                
                try await viewModel.checkLogin()
                if viewModel.needLogin.value { return }
                
                try await viewModel.checkParticipating()
                if !viewModel.isParticipating.value { return }
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    coordinator?.setNavigationController(MainViewController())    // TODO: animated 고민
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
