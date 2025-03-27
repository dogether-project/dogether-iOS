//
//  OnboardingViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import UIKit
import SnapKit

import AuthenticationServices

final class OnboardingViewController: BaseViewController {
    private let viewModel = OnboardingViewModel()

    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let onboardingStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private func onboardingStepStackView(step: OnboardingSteps) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: step.title,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        titleLabel.textColor = .grey0
        titleLabel.numberOfLines = 0
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: step.subTitle,
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        subTitleLabel.textColor = .grey200
        subTitleLabel.numberOfLines = 0

        let imageView = UIImageView(image: step.image)
        let aspectRatio = imageView.frame.height / imageView.frame.width
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, imageView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(8, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(imageView.snp.width).multipliedBy(aspectRatio)
        }
        
        return stackView
    }
    
    private let pageControl = UIPageControl()
    
    private let nextButton = DogetherButton(title: "다음", status: .enabled)

    private var signInButton =  {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(viewModel.onboardingStep),
            height: scrollView.frame.height
        )
        
        for pageIndex in 0 ..< viewModel.onboardingStep {
            guard let onboardingStep = OnboardingSteps(rawValue: pageIndex + 1) else { return }
            onboardingStackView.addArrangedSubview(onboardingStepStackView(step: onboardingStep))
        }
        
        pageControl.numberOfPages = viewModel.onboardingStep
        
        nextButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let nextPage = pageControl.currentPage + 1
                if nextPage < pageControl.numberOfPages {
                    let nextOffset = CGPoint(x: CGFloat(nextPage) * view.frame.width, y: 0)
                    scrollView.setContentOffset(nextOffset, animated: true)
                }
            }, for: .touchUpInside
        )
        
        signInButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    try await self.viewModel.signInWithApple()
                    guard let destination = self.viewModel.destination else { return }
                    await MainActor.run {
                        self.coordinator?.setNavigationController(destination)
                    }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, nextButton, signInButton].forEach { view.addSubview($0) }
        
        [onboardingStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        onboardingStackView.snp.makeConstraints {
            // FIXME: 26 -> pageControl.height, 16 -> buttonBottomPadding, 50 -> button.height
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-(26 + 16 + 50) / 2)
            $0.width.equalTo(view.frame.width * CGFloat(viewModel.onboardingStep))
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(onboardingStackView.snp.bottom)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        signInButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - scroll
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let isLastPage = pageControl.currentPage == pageControl.numberOfPages - 1
        
        signInButton.isHidden = !isLastPage
        nextButton.isHidden = isLastPage
    }
}
