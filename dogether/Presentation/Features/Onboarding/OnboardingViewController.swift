//
//  OnboardingViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    private let onboardingPage = OnboardingPage()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        onboardingPage.frame = view.frame
    }
    
    override func configureAction() {
        onboardingPage.signInAction = UIAction { [weak self] _ in
            guard let self else { return }
            Task {
                try await self.viewModel.signInWithApple()
                
                try await self.viewModel.checkParticipating()
                if self.viewModel.needParticipating.value { return }
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    coordinator?.setNavigationController(MainViewController())
                }
            }
        }
    }
    
    override func configureHierarchy() {
        [onboardingPage].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        onboardingPage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindViewModel() {
        viewModel.onboardingStep
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] step in
                guard let self else { return }
                onboardingPage.viewDidUpdate(step)
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
