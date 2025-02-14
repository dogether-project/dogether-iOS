//
//  LoginViewController.swift
//  dogether
//
//  Created by 박지은 on 2/5/25.
//

import UIKit
import AuthenticationServices
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let viewModel = LoginViewModel()

    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let pageControl = {
        let control = UIPageControl()
        return control
    }()
    
    private let contentView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    private lazy var signInButton =  {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 12
        button.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [scrollView, pageControl, signInButton].forEach { view.addSubview($0) }
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

        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageControl.snp.bottom).offset(64)
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        for i in 1...3 {
            let pageView = createPageView(index: i)
            contentView.addArrangedSubview(pageView)
        }
    }
    
    @objc private func signInButtonClicked() {
        Task {
            let response = try await viewModel.singInWithApple()
            print("✅ 로그인 성공: \(response.name), 토큰: \(response.accessToken)")
            
            UserDefaultsManager.shared.userFullName = response.name
            UserDefaultsManager.shared.accessToken = response.accessToken
            
            // 로그인 성공 후 3초 뒤 StartView로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                let startVC = StartViewController()
                self?.navigationController?.setViewControllers([startVC], animated: true)
            }
        }
    }
    
    private func createPageView(index: Int) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.head1B
        label.textColor = .grey0
        label.numberOfLines = 0
        
        let view = UIView()
        let imageView = UIImageView(image: .logo)
        
        switch index {
        case 1:
            label.text = "매일 자정, 목표를 세우고\n피드백을 받아보세요!"
        case 2:
            label.text = "투두를 사진으로 인증하면,\n익명 팀원이 검토해줘요!"
        case 3:
            label.text = "팀원의 인증을 검사해야,\n새로운 목표를 설정할 수 있어요!"

        default:
            break
        }
        
        [label, imageView].forEach {
            view.addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(58)
        }
        return view
    }
}

// MARK: - 로그인 인증 화면 요청
extension OnboardingViewController: ASWebAuthenticationPresentationContextProviding {
    
    // 인증창을 보여주기 위한 메서드(인증창을 보여줄 화면을 설정)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
