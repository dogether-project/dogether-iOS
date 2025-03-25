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
    
    private let pageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        return pageControl
    }()
    
    private let contentView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private func pageView(step: OnboardingSteps) -> UIView {
        let view = UIView()
        
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

        
        let imageView = UIImageView()
        imageView.image = step.image
        
        [titleLabel, subTitleLabel, imageView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(340)
        }
        return view
    }
    
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
        
        for pageIndex in 0 ..< pageControl.numberOfPages {
            guard let onboardingStep = OnboardingSteps(rawValue: pageIndex + 1) else { return }
            contentView.addArrangedSubview(pageView(step: onboardingStep))
        }
        
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
        
        scrollView.addSubview(contentView)
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(470)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(view.frame.width * CGFloat(pageControl.numberOfPages)) // 페이지 개수만큼 너비 설정
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.bottom).offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(64)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(64)
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
