//
//  CertificationPage.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import UIKit

final class CertificationPage: BasePage {
    var delegate: CertificationDelegate? {
        didSet {
            thumbnailListView.delegate = delegate
            certificationListView.delegate = delegate
            certificateButton.certificationDelegate = delegate
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 정보")
    private let thumbnailListView = ThumbnailListView()
    private let certificationScrollView = UIScrollView()
    private let certificationStackView = UIStackView()
    private let certificationListView = CertificationListView()
    private let statusView = TodoStatusButton(type: .waitCertification)
    private let contentLabel = UILabel()
    private let reviewFeedbackView = ReviewFeedbackView()
    private let certificateButton = DogetherButton(title: "인증하기")
    
    override func configureView() {
        certificationScrollView.showsVerticalScrollIndicator = false
        
        [certificationListView, statusView, contentLabel, reviewFeedbackView].forEach {
            certificationStackView.addArrangedSubview($0)
        }
        certificationStackView.axis = .vertical
        certificationStackView.alignment = .center
        certificationStackView.setCustomSpacing(32, after: certificationListView)
        certificationStackView.setCustomSpacing(8, after: statusView)
        certificationStackView.setCustomSpacing(16, after: contentLabel)
        
        contentLabel.textColor = .grey0
        contentLabel.numberOfLines = 0
        
        certificateButton.isHidden = false
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [navigationHeader, thumbnailListView, certificationScrollView, certificateButton].forEach { addSubview($0) }
        certificationScrollView.addSubview(certificationStackView)
    }
     
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        thumbnailListView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        certificationScrollView.snp.makeConstraints {
            $0.top.equalTo(thumbnailListView.snp.bottom).offset(12)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        certificationStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        certificationListView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(frame.width - 32)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewFeedbackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        certificateButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            navigationHeader.viewDidUpdate(datas)
            thumbnailListView.viewDidUpdate(datas)
            certificationListView.viewDidUpdate(datas)
            
            statusView.viewDidUpdate(datas.todos[datas.index].status)
            
            contentLabel.attributedText = NSAttributedString(
                string:  datas.todos[datas.index].content,
                attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
            )
            
            reviewFeedbackView.viewDidUpdate(datas)
            certificateButton.viewDidUpdate(datas)
        }
    }
}
