//
//  OnboardingViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    private let onboardingPage = OnboardingPage()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [onboardingPage].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        onboardingPage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
