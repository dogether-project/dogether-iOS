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
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let statusView = FilterButton(type: .wait)
    
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
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
        
        viewModel.todos
            .map {
                CertificationImageView(image: .logo, certificationContent: $0.certificationContent)
            }
            .forEach {
                certificationStackView.addArrangedSubview($0)
            }
        
        // TODO: set statusView
        
        contentLabel.attributedText = NSAttributedString(
            string: viewModel.todos[viewModel.currentIndex].content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        thumbnailScrollView.delegate = self
        
        certificationScrollView.delegate = self
    }
    
    override func configureHierarchy() {
        [ navigationHeader, memberInfoView,
          thumbnailScrollView, certificationScrollView,
          statusView, contentLabel
        ].forEach { view.addSubview($0) }
        [thumbnailStackView].forEach { thumbnailScrollView.addSubview($0) }
        [certificationStackView].forEach { certificationScrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        memberInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        thumbnailScrollView.snp.makeConstraints {
            $0.top.equalTo(memberInfoView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        thumbnailStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        certificationScrollView.snp.makeConstraints {
            $0.top.equalTo(thumbnailScrollView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.frame.width - 32)
        }
        
        certificationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(view.frame.width * CGFloat(viewModel.todos.count) - 32)
            $0.height.equalToSuperview()
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(certificationScrollView.snp.bottom).offset(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

// MARK: - scroll
extension MemberCertificationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === certificationScrollView {
            let index = Int(round(scrollView.contentOffset.x / view.frame.width))
            if index == viewModel.currentIndex { return }
            viewModel.setCurrentIndex(index: index)
        }
    }
}
