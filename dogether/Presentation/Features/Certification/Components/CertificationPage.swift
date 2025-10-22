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
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 정보")
    private let thumbnailListView = ThumbnailListView()
    private let certificationListView = CertificationListView()
    private let statusView = FilterButton(type: .all)
    private let contentLabel = UILabel()
    private let reviewFeedbackView = ReviewFeedbackView()
    
    override func configureView() {
//        imageView = CertificationImageView(
//            image: .logo,
//            certificationContent: todoInfo.certificationContent
//        )
        
        contentLabel.textColor = .grey0
        contentLabel.numberOfLines = 0
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [navigationHeader, thumbnailListView, certificationListView, statusView, contentLabel].forEach { addSubview($0) }
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
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            thumbnailListView.viewDidUpdate(datas)
            
//            imageView.loadImage(url: datas.todos[datas.index].certificationMediaUrl)
            
            guard let status = TodoStatus(rawValue:  datas.todos[datas.index].status),
                  let filterType = FilterTypes.allCases.first(where: { $0.tag == status.tag }) else { return }
            statusView.viewDidUpdate(filterType)
            
            contentLabel.attributedText = NSAttributedString(
                string:  datas.todos[datas.index].content,
                attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
            )
            
            if let reviewFeedback = datas.todos[datas.index].reviewFeedback {
                reviewFeedbackView.updateFeedback(feedback: reviewFeedback)
                if reviewFeedback.count > 0 {
                    addSubview(reviewFeedbackView)
                    
                    reviewFeedbackView.snp.makeConstraints {
                        $0.top.equalTo(contentLabel.snp.bottom).offset(16)
                        $0.horizontalEdges.equalToSuperview().inset(16)
                    }
                }
            }
        }
    }
}
