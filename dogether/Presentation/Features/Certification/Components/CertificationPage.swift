//
//  CertificationPage.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import UIKit

final class CertificationPage: BasePage {
    var delegate: CertificationDelegate?  {
        didSet {
            thumbnailListView.delegate = delegate
            certificationListView.delegate = delegate
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 정보")
    private let thumbnailListView = ThumbnailListView()
    private let certificationListView = CertificationListView()
    private let statusView = TodoStatusButton(type: .waitCertification)
    private let contentLabel = UILabel()
    private let reviewFeedbackView = ReviewFeedbackView()
    
    override func configureView() {
        contentLabel.textColor = .grey0
        contentLabel.numberOfLines = 0
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [navigationHeader, thumbnailListView, certificationListView,
         statusView, contentLabel, reviewFeedbackView
        ].forEach { addSubview($0) }
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
        
        certificationListView.snp.makeConstraints {
            $0.top.equalTo(thumbnailListView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(frame.width - 32)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(certificationListView.snp.bottom).offset(32)
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        reviewFeedbackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            thumbnailListView.viewDidUpdate(datas)
            certificationListView.viewDidUpdate(datas)
            
            if let status = TodoStatus(rawValue: datas.todos[datas.index].status) {
                statusView.viewDidUpdate(status)
            }
            
            contentLabel.attributedText = NSAttributedString(
                string:  datas.todos[datas.index].content,
                attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
            )
            
            reviewFeedbackView.viewDidUpdate(datas)
        }
    }
}
