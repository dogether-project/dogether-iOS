//
//  ExaminatePage.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import UIKit

final class ExaminatePage: BasePage {
    var delegate: ExaminateDelegate? {
        didSet {
            
        }
    }
    
    private let scrollView = UIScrollView()
    private let closeButton = DogetherButton("보내기")
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let imageView = CertificationImageView(type: .logo)
    private let contentLabel = UILabel()
    private let rejectButton = ExaminateButton(type: .reject)
    private let approveButton = ExaminateButton(type: .approve)
    private let examinationStackView = UIStackView()
    private let reviewFeedbackView = ReviewFeedbackView()
    
    private(set) var currentReview: ReviewEntity?
    
    override func configureView() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        
        titleLabel.text = "투두를 검사해주세요!"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.head1B
        titleLabel.textAlignment = .center
        
        contentLabel.textColor = .grey0
        contentLabel.numberOfLines = 0
        
        examinationStackView.axis = .horizontal
        examinationStackView.spacing = 11
        examinationStackView.distribution = .fillEqually
    }
    
    override func configureAction() {
//        [rejectButton, approveButton].forEach { button in
//            button.addAction(
//                UIAction { [weak self, weak button] _ in
//                    guard let self, let button,
//                          let type = FilterTypes.allCases.first(where: { $0.tag == button.tag }),
//                          let reviewResult = type.reviewResult else { return }
//                    
//                    viewModel.setResult(reviewResult)
//                    viewModel.setReviewFeedback()
//                    
//                    todoExaminationModalityView.removeFeedback()
//                    todoExaminationModalityView.updateButtonBackgroundColor(type: type)
//                    // FIXME: 추후 수정
//                    var viewDatas = todoExaminationModalityView.closeButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
//                    viewDatas.status = type == .approve ? .enabled : .disabled
//                    todoExaminationModalityView.closeButton.updateView(viewDatas)
//                    
//                    coordinator?.showPopup(self, type: .reviewFeedback) { reviewFeedback in
//                        guard let reviewFeedback = reviewFeedback as? String else { return }
//                        self.viewModel.setReviewFeedback(reviewFeedback)
//                        self.todoExaminationModalityView.addFeedback(feedback: reviewFeedback)
//                        viewDatas.status = .enabled
//                        self.todoExaminationModalityView.closeButton.updateView(viewDatas)
//                    }
//                }, for: .touchUpInside
//            )
//        }
//        
//        closeButton.addAction(
//            UIAction { [weak self] _ in
//                guard let self else { return }
//                Task {
//                    try await self.viewModel.reviewTodo()
//                    await MainActor.run {
//                        self.viewModel.setCurrent(self.viewModel.current + 1)
//                        if self.viewModel.reviews.count == self.viewModel.current {
//                            self.coordinator?.hideModal()
//                        } else {
//                            self.viewModel.setResult()
//                            self.viewModel.setReviewFeedback()
//                            
//                            self.todoExaminationModalityView.removeFeedback()
//                            self.todoExaminationModalityView.updateButtonBackgroundColor(type: .all)
//                            // FIXME: 추후 수정
//                            var viewDatas = self.todoExaminationModalityView.closeButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
//                            viewDatas.status = .disabled
//                            self.todoExaminationModalityView.closeButton.updateView(viewDatas)
//                            self.updateView()
//                        }
//                    }
//                }
//            }, for: .touchUpInside
//        )
    }
    
    override func configureHierarchy() {
        [rejectButton, approveButton].forEach { examinationStackView.addArrangedSubview($0) }
        
        [titleLabel, imageView, contentLabel, examinationStackView].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(60, after: titleLabel)
        contentStackView.setCustomSpacing(16, after: imageView)
        contentStackView.setCustomSpacing(16, after: contentLabel)
        
        [scrollView, closeButton].forEach { addSubview($0) }
        [contentStackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50 + 16 + 16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(scrollView.snp.width).offset(-32)
        }
        
        examinationStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ExaminateViewDatas {
            if currentReview != datas.reviews[datas.index] {
                currentReview = datas.reviews[datas.index]
                
                let certificationImageViewDatas = CertificationImageViewDatas(
                    image: .logo,
                    imageUrl: datas.reviews[datas.index].mediaUrl,
                    content: datas.reviews[datas.index].content,
                    certificator: datas.reviews[datas.index].doer
                )
                imageView.updateView(certificationImageViewDatas)
                
                contentLabel.attributedText = NSAttributedString(
                    string: datas.reviews[datas.index].todoContent,
                    attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
                )
            }
        }
            
            
        if let datas = data as? DogetherButtonViewDatas {
            closeButton.updateView(datas)
        }
    }
}
