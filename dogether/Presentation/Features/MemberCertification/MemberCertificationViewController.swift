//
//  MemberCertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import UIKit
import SnapKit

final class MemberCertificationViewController: BaseViewController {
    let viewModel = MemberCertificationViewModel()
    
    private let navigationHeader = NavigationHeader(title: "그룹원 인증 정보")
    
    private let memberInfoView = RankingView(type: .memberInfoView)
    
    private let thumbnailScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let thumbnailStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let certificationScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let certificationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        guard let memberInfo = viewModel.memberInfo else { return }
        memberInfoView.setExtraInfo(ranking: memberInfo)
        
        viewModel.todos
            .map { _ in
                ThumbnailView(thumbnailStatus: .pending)
            }
            .forEach {
                thumbnailStackView.addArrangedSubview($0)
            }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        thumbnailScrollView.delegate = self
        
        certificationScrollView.delegate = self
    }
    
    override func configureHierarchy() {
        [navigationHeader, memberInfoView, thumbnailStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        memberInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        thumbnailStackView.snp.makeConstraints {
            $0.top.equalTo(memberInfoView.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(16)
        }
    }
}

// MARK: - scroll
extension MemberCertificationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / view.frame.width)
        print("index: \(index)")
    }
}
