//
//  GroupJoinViewController.swift
//  dogether
//
//  Created by 박지은 on 2/12/25.
//

import UIKit
import SnapKit

final class GroupJoinViewController: BaseViewController {
    private let viewModel = GroupJoinViewModel()
    
    private let dogetherHeader = NavigationHeader(title: "그룹 가입하기")
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "초대코드 입력"
        label.textColor = .grey0
        label.font = Fonts.emphasis2B
        return label
    }()
    
    private let subTitleLabel = UILabel()
    
    private let codeTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "코드입력 (6자리 이상)",
            attributes: [
                .foregroundColor: UIColor.grey300
            ]
        )
        textField.font = Fonts.body1S // ❌
        textField.textColor = .grey0
        textField.backgroundColor = .grey800
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.keyboardType = .asciiCapable
        textField.tintColor = .blue300
        textField.autocorrectionType = .no
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 16, height: textField.frame.height)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private var joinButton = DogetherButton(title: "가입하기", status: .disabled)
    
    private var joinButtonBottomConstraint: Constraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeTextField.becomeFirstResponder()
    }
    
    override func configureView() {
        updateSubTitleLabel()
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        dogetherHeader.delegate = self
        codeTextField.delegate = self
        
        codeTextField.addAction(
            UIAction { [weak self] action in
                guard let self, let textField = action.sender as? UITextField else { return }
                
                let text = textField.text ?? ""
                let trimmed = String(text.prefix(viewModel.codeLength)) // 최대 글자 수 제한
                textField.text = trimmed
                viewModel.setCode(trimmed)
                
                if trimmed.count == viewModel.codeLength {
                    joinButton.setButtonStatus(status: .enabled)
                } else {
                    joinButton.setButtonStatus(status: .disabled)
                }
            },
            for: .editingChanged
        )

        joinButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    do {
                        try await self.viewModel.joinGroup()
                        guard let groupInfo = self.viewModel.groupInfo else { return }
                        await MainActor.run {
                            let completeViewController = CompleteViewController()
                            completeViewController.viewModel.groupType = .join
                            completeViewController.viewModel.groupInfo = groupInfo
                            self.coordinator?.setNavigationController(completeViewController)
                        }
                    } catch {
                        self.viewModel.handleCodeError()
                        
                        self.updateSubTitleLabel()
                        self.updateCodetextField()
                        
                        self.joinButton.setButtonStatus(status: .disabled)
                    }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [dogetherHeader, titleLabel, subTitleLabel, codeTextField, joinButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.height.equalTo(36)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(25)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            self.joinButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

// MARK: - update UI
extension GroupJoinViewController {
    private func updateSubTitleLabel() {
        subTitleLabel.text = viewModel.status.text
        subTitleLabel.textColor = viewModel.status.textColor
        subTitleLabel.font = viewModel.status.font
    }
    
    private func updateCodetextField() {
        codeTextField.layer.borderColor = viewModel.status.textColor.cgColor
        codeTextField.text = ""
    }
}

// MARK: - about keyboard
extension GroupJoinViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if joinButton.isEnabled {
            joinButton.sendActions(for: .touchUpInside)
        }
        return true
    }

    private func setTextFieldBorderColor() {
        if codeTextField.isFirstResponder {
            codeTextField.layer.borderColor = UIColor.blue300.cgColor
            codeTextField.layer.borderWidth = 1.5
        } else {
            codeTextField.layer.borderColor = UIColor.clear.cgColor
            codeTextField.layer.borderWidth = 0
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
        
        UIView.animate(withDuration: 0.35) {
            self.joinButtonBottomConstraint?.update(inset: 270)
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
        
        UIView.animate(withDuration: 0.35) {
            self.joinButtonBottomConstraint?.update(inset: 16)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
