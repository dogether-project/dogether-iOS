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
        label.font = Fonts.emphasis2B
        label.textColor = .grey0
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.text = "초대받은 링크에서 초대코드를 확인할 수 있어요"
        label.font = Fonts.body1R
        label.textColor = .grey200
        label.isHidden = false
        return label
    }()
    
    private let errorLabel = {
        let label = UILabel()
        label.text = "해당 번호는 존재하지 않아요!"
        label.textColor = .dogetherRed
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
        button.titleLabel?.font = Fonts.body1B
        button.setTitleColor(.grey400, for: .normal)
        button.backgroundColor = .grey500
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
        
        navigationItem.title = "그룹 가입하기"
    }
    
    @objc private func joinButtonClicked() {
        
        Task {
            do {
                let request = JoinGroupRequest(joinCode: enterCode) // "kelly-join-code"
                // TODO: 추후 이슈 #6 수정되면 response 수정하고 completeViewController로 데이터 넘기는 작업 추가
                let response: JoinGroupResponse = try await NetworkManager.shared.request(GroupsRouter.joinGroup(joinGroupRequest: request))
                
                let completeViewController = CompleteViewController(type: .join)
                completeViewController.viewModel.joinGroupResponse = response
                NavigationManager.shared.setNavigationController(completeViewController)

            } catch {
                print("❌ 가입 실패: \(error)")
                
                subtitleLabel.isHidden = true
                errorLabel.isHidden = false
                
                // 텍스트필드 초기화
                textFields.forEach { textField in
                    textField.text = ""
                }
                
                textFields.first?.becomeFirstResponder()
                
                textFields.forEach { textField in
                    textField.backgroundColor = .grey700
                    textField.textColor = .black
                }
                
                joinButton.isEnabled = false
                joinButton.backgroundColor = .grey500
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// TODO: - 빈 텍스트필드일때 백스페이스 액션이 안먹히는 상황이라서 텍스트필드를 개별로 나누는 작업을 해야함
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
            textField.backgroundColor = .grey700
            textField.layer.cornerRadius = 15
            textField.textColor = .grey100
            textField.font = Fonts.head1R
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
            } else {
                // 마지막 입력 후 키보드 내리기
                textField.resignFirstResponder()
                joinButton.isEnabled = true
            }
        }
        
        // 입력중인 텍스트필드 border 색상 변경
        setTextFieldBorderColor()
        
        joinButton.backgroundColor = joinButton.isEnabled ? .blue300 : .grey100
        joinButton.setTitleColor(joinButton.isEnabled ? .grey800 : .grey400, for: .normal)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 첫번째 텍스트필드부터 입력
        if let index = textFields.firstIndex(of: textField) {
            return index == 0 || !textFields[index - 1].text!.isEmpty
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 빈 텍스트필드에 무언가를 입력할때
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
                return false
            }
        }
        // 한글자만 입력 가능
        return textField.text?.isEmpty ?? true
    }
}
