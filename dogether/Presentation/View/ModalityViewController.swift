//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import Foundation
import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    var viewModel = ModalityViewModel()
    
    // TODO: 현재는 TodoExamination 단일 종류만 존재하지만 추후 확장
    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        return view
    }()
    
    private let titlaLabel = {
        let label = UILabel()
        label.text = "투두를 검사해주세요!"
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private var todoExaminationModalityView = UIView()
    
    private var closeButton = DogetherButton(action: { }, title: "보내기", status: .disabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        closeButton.action = didTapCloseButton
        todoExaminationModalityView = ExaminationModalityView(buttonAction: { type in
            switch type {
            case .reject:
                self.viewModel.setResult(.reject)
                self.viewModel.setRejectReason()
                self.closeButton.setButtonStatus(status: .disabled)
                PopupManager.shared.showPopup(type: .rejectReason, completeAction: { rejectReason in
                    self.viewModel.setRejectReason(rejectReason)
                    self.closeButton.setButtonStatus(status: .enabled)
                })
                
            case .approve:
                self.viewModel.setResult(.approve)
                self.closeButton.setButtonStatus(status: .enabled)
                
            default:
                return
            }
        }, review: viewModel.reviews[viewModel.current])
    }
    
    override func configureHierarchy() {
        [backgroundView, titlaLabel, todoExaminationModalityView, closeButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titlaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.height.equalTo(36)
        }
        
        todoExaminationModalityView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    private func didTapCloseButton() {
        Task { @MainActor in
            try await viewModel.reviewTodo()
            // TODO: 검사 할 투두가 여러개일 때 다음 투두로 넘어가는 기능은 추후 구현
//            viewModel.setCurrent(viewModel.current + 1)
//            if viewModel.reviews.count == viewModel.current {
                ModalityManager.shared.dismiss()
//            } else {
//                viewModel.setResult()
//                viewModel.setRejectReason()
//                configureView() // TODO: 추후 확인
//            }
        }
    }
}
