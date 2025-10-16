//
//  OnboardingViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

final class OnboardingViewController: BaseViewController {
    private let onboardingPage = OnboardingPage()
    private let viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        onboardingPage.delegate = self
        
        pages = [onboardingPage]
        
        super.viewDidLoad()
    }
}

// MARK: - delegate
protocol OnboardingDelegate {
    func signInAction()
}

extension OnboardingViewController: OnboardingDelegate {
    func signInAction() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.signInWithApple()
            
            if try await viewModel.checkParticipating() {
                coordinator?.setNavigationController(StartViewController())
                return
            }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                coordinator?.setNavigationController(MainViewController())
            }
        }
    }
}
