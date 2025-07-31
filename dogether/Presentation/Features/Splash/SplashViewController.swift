//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
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
        }
    }
    
    override func bindViewModel() {
        viewModel.needUpdate
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isNeeded in
                if isNeeded {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        coordinator?.setNavigationController(UpdateViewController())    // TODO: animated 고민
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.needLogin
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isNeeded in
                if isNeeded {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        coordinator?.setNavigationController(OnboardingViewController())    // TODO: animated 고민
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isParticipating
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isParticipating in
                if !isParticipating {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        coordinator?.setNavigationController(StartViewController())    // TODO: animated 고민
                    }
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
    private func runSplashFlow() async {
        do {
            try await viewModel.launchApp()
            try await viewModel.checkUpdate()
            
            if viewModel.needUpdate {
                updateView()
            } else {
                try await navigateToInitialDestination()
            }
        } catch {
            await MainActor.run {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        Task {
                            await self.runSplashFlow()
                        }
                    },
                    showCloseButton: false
                )
            }
        }
    }
    
    @MainActor
    func updateView() {
        logoView.isHidden = viewModel.needUpdate
        updateContainer.isHidden = !viewModel.needUpdate
        updateButton.isHidden = !viewModel.needUpdate
    }
    
    private func navigateToInitialDestination() async throws {
        let destination = try await viewModel.getDestination()
        await MainActor.run {
            coordinator?.setNavigationController(destination)
        }
    }
}
