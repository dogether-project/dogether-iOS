//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    var viewModel = ModalityViewModel()
    
    // TODO: 현재는 TodoExamination 단일 종류만 존재하지만 추후 확장
    private let titlaLabel = {
        let label = UILabel()
        label.text = "투두를 검사해주세요!"
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private var todoExaminationModalityView = BasePopupView()
    
    private var closeButton = DogetherButton(title: "보내기", status: .disabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .grey900
        
        todoExaminationModalityView = ExaminationModalityView(review: viewModel.reviews[viewModel.current])
    }
    
    override func configureAction() {
        if let modalView = todoExaminationModalityView as? ExaminationModalityView {
            [modalView.rejectButton, modalView.approveButton].forEach { button in
                button.addAction(
                    UIAction { [weak self, weak button] _ in
                        guard let self, let button, let type = FilterTypes.allCases.first(where: { $0.tag == button.tag }) else { return }
                        modalView.updateButtonBackgroundColor(type: type)
                        
                        switch type {
                        case .reject:
                            viewModel.setResult(.reject)
                            viewModel.setRejectReason()
                            closeButton.setButtonStatus(status: .disabled)
                            coordinator?.showPopup(self, type: .rejectReason) { rejectReason in
                                guard let rejectReason = rejectReason as? String else { return }
                                self.viewModel.setRejectReason(rejectReason)
                                self.closeButton.setButtonStatus(status: .enabled)
                            }
                            
                        case .approve:
                            viewModel.setResult(.approve)
                            closeButton.setButtonStatus(status: .enabled)
                            
                        default:
                            return
                        }
                    }, for: .touchUpInside
                )
            }
        }
        
        closeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    try await self.viewModel.reviewTodo()
                    // TODO: 검사 할 투두가 여러개일 때 다음 투두로 넘어가는 기능은 추후 구현
        //            viewModel.setCurrent(viewModel.current + 1)
        //            if viewModel.reviews.count == viewModel.current {
                    self.coordinator?.hideModal()
        //            } else {
        //                viewModel.setResult()
        //                viewModel.setRejectReason()
        //                configureView() // TODO: 추후 확인
        //            }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [titlaLabel, todoExaminationModalityView, closeButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        titlaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.height.equalTo(36)
        }
        
        todoExaminationModalityView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
