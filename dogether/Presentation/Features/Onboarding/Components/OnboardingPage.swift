//
//  OnboardingPage.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import AuthenticationServices

final class OnboardingPage: BasePage {
    var signInAction: UIAction?
    
    private let scrollView = UIScrollView()
    private let onboardingStackView = UIStackView()
    private let pageControl = UIPageControl()
    private let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        
        onboardingStackView.axis = .horizontal
        onboardingStackView.distribution = .fillEqually
        
        signInButton.cornerRadius = 12
    }
    
    override func configureAction() {
        scrollView.delegate = self
        
        pageControl.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let page = pageControl.currentPage
                let offset = CGPoint(x: CGFloat(page) * scrollView.frame.width, y: 0)
                scrollView.setContentOffset(offset, animated: true)
            }, for: .valueChanged
        )
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, signInButton].forEach { self.addSubview($0) }
        
        [onboardingStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        onboardingStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(onboardingStackView.snp.bottom)
        }
        
        signInButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: Any?) {
        guard let step = data as? Int else { return }
        
        scrollView.contentSize.width = frame.width * CGFloat(step)
        
        for pageIndex in 0 ..< step {
            guard let onboardingStep = OnboardingSteps(rawValue: pageIndex + 1) else { return }
            onboardingStackView.addArrangedSubview(onboardingStepStackView(step: onboardingStep))
        }
        
        pageControl.numberOfPages = step
    }
    
    override func updateAction(_ data: Any?) {
        if let signInAction { signInButton.addAction(signInAction, for: .touchUpInside) }
    }
    
    override func updateConstraints(_ data: Any?) {
        guard let step = data as? Int else { return }
        
        let pageControlHeight: CGFloat = 26
        let buttonBottomPadding: CGFloat = 16
        let buttonHeight: CGFloat = 50
        
        onboardingStackView.snp.remakeConstraints {
            $0.centerY.equalToSuperview().offset(-(pageControlHeight + buttonBottomPadding + buttonHeight) / 2)
            $0.width.equalToSuperview().multipliedBy(step)
        }
    }
}

// MARK: - private func
extension OnboardingPage {
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
}

// MARK: - scroll
extension OnboardingPage: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.width == .zero { return }
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
