//
//  GroupJoinViewController.swift
//  dogether
//
//  Created by 박지은 on 2/12/25.
//

import UIKit

final class GroupJoinViewController: BaseViewController {
    private let viewModel = GroupJoinViewModel()
    
    private let navigationHeader = NavigationHeader(title: "그룹 가입하기")
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "초대번호 입력"
        label.textColor = .grey0
        label.font = Fonts.emphasis2B
        return label
    }()
    
    private let subTitleLabel = UILabel()
    
    private var textFields: [UITextField] = []
    
    // MARK: 숨겨두고 키보드 입력을 받는 textField
    private let textField = {
        let textField = UITextField()
        textField.alpha = 0
        textField.isHidden = true
        return textField
    }()
    
    private func codeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        label.backgroundColor = .grey700
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }
    
    private let codeLabelStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private var joinButton = DogetherButton(title: "가입하기", status: .disabled)
    
    // MARK: about keyboardOserver
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
        updateCodeLabelFocus()
    }
    
    override func configureView() {
        updateSubTitleLabel()

        (0 ..< viewModel.codeLength).forEach { _ in codeLabelStackView.addArrangedSubview(codeLabel()) }
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        codeLabelStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyboard)))
        
        navigationHeader.delegate = self
        
        textField.delegate = self
        textField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.setCode(textField.text)
                updateCodeLabels()
            }, for: .editingChanged
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
                        
                        self.joinButton.setButtonStatus(status: .disabled)
                    }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, titleLabel, subTitleLabel, textField, codeLabelStackView, joinButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationHeader.snp.bottom).offset(44)
            $0.height.equalTo(36)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(25)
        }
        
        codeLabelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(89)
            $0.width.equalTo(48 * viewModel.codeLength + 4 * (viewModel.codeLength - 1))
            $0.height.equalTo(60)
        }
        
        joinButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
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
    
    private func updateCodeLabels() {
        for i in 0 ..< codeLabelStackView.subviews.count {
            guard let codeLabel = codeLabelStackView.subviews[i] as? UILabel else { return }
            if i < viewModel.code.count {
                codeLabel.text = String(Array(viewModel.code)[i])
            } else {
                codeLabel.text = ""
            }
        }
        updateCodeLabelFocus()
        if viewModel.code.count == viewModel.codeLength {
            textField.resignFirstResponder()
            joinButton.setButtonStatus(status: .enabled)
        }
    }
    
    private func updateCodeLabelFocus() {
        for i in 0 ..< codeLabelStackView.subviews.count {
            if i == viewModel.code.count {
                codeLabelStackView.subviews[i].layer.borderColor = UIColor.blue300.cgColor
                codeLabelStackView.subviews[i].layer.borderWidth = 1.5
            } else {
                codeLabelStackView.subviews[i].layer.borderColor = UIColor.clear.cgColor
                codeLabelStackView.subviews[i].layer.borderWidth = 0
            }
        }
    }
}

// MARK: - about keyboard
extension GroupJoinViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setTextFieldBorderColor() {
        for textField in textFields {
            if textField.isFirstResponder {
                textField.layer.borderColor = UIColor.blue300.cgColor
                textField.layer.borderWidth = 1.5
            } else {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        // 첫번째 텍스트필드부터 입력
//        if let index = textFields.firstIndex(of: textField) {
//            return index == 0 || !textFields[index - 1].text!.isEmpty
//        }
//        return false
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        // 빈 텍스트필드에 무언가를 입력할때
//        if string.isEmpty {
//            if let currentText = textField.text, !currentText.isEmpty {
//                // 현재 값이 있으면 삭제
//                textField.text = ""
//                
//                if let index = textFields.firstIndex(of: textField), index > 0 {
//                    let previousTextField = textFields[index - 1]
//                    
//                    DispatchQueue.main.async {
//                        previousTextField.becomeFirstResponder()
//                    }
//                }
//                return false
//            }
//        }
//        // 한글자만 입력 가능
//        return textField.text?.isEmpty ?? true
//    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func showKeyboard() { textField.becomeFirstResponder() }
}
