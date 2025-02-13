//
//  GroupJoinViewController.swift
//  dogether
//
//  Created by 박지은 on 2/12/25.
//

import UIKit

final class GroupJoinViewController: BaseViewController {
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "초대번호 입력"
        label.font = Fonts.emphasisB
        label.textColor = .black
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.text = "초대받은 링크에서 초대코드를 확인할 수 있어요"
        label.font = Fonts.body1R
        label.textColor = .grey500
        label.isHidden = false
        return label
    }()
    
    private let errorLabel = {
        let label = UILabel()
        label.text = "해당 번호는 존재하지 않아요!"
        label.textColor = .pointRed
        label.isHidden = true
        return label
    }()
    
    private var textFields: [UITextField] = []
    
    private let codeLength = 6
    
    private var enterCode: String {
        return textFields.compactMap { $0.text }.joined()
    }
    
    private lazy var joinButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .grey100
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(self, action: #selector(joinButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        setupTapGesture()
    }
    
    override func configureHierarchy() {
        [titleLabel, subtitleLabel, errorLabel, joinButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        errorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    override func configureView() {
        
        // TODO: - 네비게이션 타이틀 확인하기
        navigationItem.title = "그룹 가입하기"
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func joinButtonClicked() {
        
        let sampleCode = "123456"
        
        if enterCode == sampleCode {
            print("가입 성공")
        } else {
            subtitleLabel.isHidden = true
            errorLabel.isHidden = false
            
            // 텍스트필드 초기화
            textFields.forEach { textField in
                textField.text = ""
            }
            
            textFields.first?.becomeFirstResponder()
            
            textFields.forEach { textField in
                textField.backgroundColor = .blue100
                textField.textColor = .black
            }
            
            joinButton.isEnabled = false
            joinButton.backgroundColor = .grey100
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension GroupJoinViewController: UITextFieldDelegate {
    
    private func configureTextFields() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(80)
            $0.width.equalTo(308)
            $0.height.equalTo(60)
        }
        
        for _ in 0 ..< codeLength {
            let textField = UITextField()
            textField.backgroundColor = .blue100
            textField.layer.cornerRadius = 15
            textField.textColor = .black
            textField.textAlignment = .center
            textField.keyboardType = .numberPad // 숫자만 입력 가능(추후 변경 가능)
            textField.delegate = self
            textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            
            stackView.addArrangedSubview(textField)
            textFields.append(textField)
        }
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        
        guard let text = textField.text, !text.isEmpty else { return }
        
        for (index, textF) in textFields.enumerated() where textF == textField {
            if index < textFields.count - 1 {
                textFields[index + 1].becomeFirstResponder()
            }
        }
        
        // 6자리 입력 완료 시 색상 변경
        if textFields.allSatisfy({ !$0.text!.isEmpty }) {
            textFields.forEach { text in
                text.backgroundColor = .grey900
                text.textColor = .white
            }
            joinButton.isEnabled = true
            view.endEditing(true)
        }
        joinButton.backgroundColor = joinButton.isEnabled ? .blue300 : .grey100
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            
            if let currentText = textField.text, !currentText.isEmpty {
                // 현재 값이 있으면 삭제
                textField.text = ""
                if let index = textFields.firstIndex(of: textField), index > 0 {
                    let previousTextField = textFields[index - 1]
                    
                    DispatchQueue.main.async {
                        previousTextField.becomeFirstResponder()
                    }
                }
            }
            
            // TODO: - 현재 값이 없을때 백스페이스 했을 경우 이전 입력했던 문자 없애기
            
            return false
        }
        // 한글자만 입력 가능
        return textField.text?.isEmpty ?? true
    }
}
