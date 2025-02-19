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
        // TODO: 추후 수정
        let todoInfos: [TodoInfo] = []
        
        closeButton.action = didTapCloseButton
        todoExaminationModalityView = ExaminationModalityView(buttonAction: { type in
            switch type {
            case .reject:
                // TODO: rejectReason 초기화
                self.closeButton.setButtonStatus(status: .disabled)
                PopupManager.shared.showPopup(type: .rejectReason, completeAction: { rejectReason in
                    // TODO: rejectReason 재정의
                    self.closeButton.setButtonStatus(status: .enabled)
                })
                
            case .approve:
                self.closeButton.setButtonStatus(status: .enabled)
                
            default:
                return
            }
        }, todoInfo: todoInfos[0])
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
        // TODO: 끝이 아니라면 다음으로
        ModalityManager.shared.dismiss()
    }
}
