//
//  GroupCreateViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class GroupCreateViewController: BaseViewController {
    private let viewModel = GroupCreateViewModel()
    
    private let dogetherHeader = NavigationHeader(title: "그룹 만들기")
    
    private func stepLabel(step: CreateGroupSteps) -> UILabel {
        let label = UILabel()
        label.text = String(step.rawValue)
        label.textColor = viewModel.currentStep == step ? .grey900 : .grey300
        label.textAlignment = .center
        label.font = Fonts.body2R
        label.backgroundColor = viewModel.currentStep == step ? .blue100 : .grey700
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.tag = step.rawValue
        return label
    }
    private var stepOne = UILabel()
    private var stepTwo = UILabel()
    private var stepThree = UILabel()
    private var stepFour = UILabel()
    
    private func stepLabelStackView(labels: [UILabel]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var stepLabelStackView = UIStackView()
    
    private let stepDescriptionLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let completeButton = DogetherButton(title: "다음", status: .disabled)
    
    private func stepView(step: CreateGroupSteps) -> UIView {
        let view = UIView()
        view.isHidden = viewModel.currentStep != step
        view.tag = step.rawValue
        return view
    }
    private var stepOneView = UIView()
    private var stepTwoView = UIView()
    private var stepThreeView = UIView()
    private var stepFourView = UIView()
    
    private func componentTitleLabel(componentTitle: String) -> UILabel {
        let label = UILabel()
        label.text = componentTitle
        label.textColor = .grey200
        label.font = Fonts.body1B
        return label
    }
    private var groupName = UILabel()
    private var memberCount = UILabel()
    private var todoLimit = UILabel()
    private var duration = UILabel()
    private var startAt = UILabel()
    
    // TODO: 추후 공용 컴포넌트로 빼기
    private let groupNameView = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        return view
    }()
    private let groupNameTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "멋진 그룹명으로 동기부여를 해보세요 !",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grey300]
        )
        textField.text = ""
        textField.textColor = .grey0
        textField.font = Fonts.body1S
        textField.tintColor = .blue300
        textField.returnKeyType = .done
        return textField
    }()
    private let groupNameCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.font = Fonts.smallS
        return label
    }()
    private let groupNameMaxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey300
        label.font = Fonts.smallS
        return label
    }()
    
    private var memberCountView = UIView()
    
    private var todoLimitView = UIView()
    
    private let threeDaysButton = DurationButton(duration: .threeDays)
    private let oneWeekButton = DurationButton(duration: .oneWeek)
    private let twoWeeksButton = DurationButton(duration: .twoWeeks)
    private let fourWeeksButton = DurationButton(duration: .fourWeeks)
    
    private let todayButton = StartAtButton(startAt: .today)
    private let tomorrowButton = StartAtButton(startAt: .tomorrow)
    
    private func horizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationRow1 = UIStackView()
    private var durationRow2 = UIStackView()
    private var startAtStack = UIStackView()
    
    private func verticalStackView(stacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stacks)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationStack = UIStackView()
    
    private let dogetherGroupInfo = DogetherGroupInfo()
    
    // MARK: about keyboardOserver
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.becomeFirstResponder()
        setupKeyboardHandling()
    }
    
    override func configureView() {
        updateDuration()
        updateStartAt()
        
        dogetherHeader.delegate = self
        
        stepOne = stepLabel(step: .one)
        stepTwo = stepLabel(step: .two)
        stepThree = stepLabel(step: .three)
        stepFour = stepLabel(step: .four)
        stepLabelStackView = stepLabelStackView(labels: [stepOne, stepTwo, stepThree, stepFour])
        
        stepDescriptionLabel.text = viewModel.currentStep.description
        
        stepOneView = stepView(step: .one)
        stepTwoView = stepView(step: .two)
        stepThreeView = stepView(step: .three)
        stepFourView = stepView(step: .four)
        
        completeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                if viewModel.currentStep == .four {
                    Task {
                        try await self.viewModel.createGroup()
                        guard let joinCode = self.viewModel.joinCode else { return }
                        await MainActor.run {
                            let completeViewController = CompleteViewController()
                            completeViewController.viewModel.groupType = .create
                            completeViewController.viewModel.joinCode = joinCode
                            self.coordinator?.setNavigationController(completeViewController)
                        }
                    }
                } else {
                    guard let nextStep = CreateGroupSteps(rawValue: viewModel.currentStep.rawValue + 1) else { return }
                    viewModel.updateStep(step: nextStep)
                    updateStep()
                }
            }, for: .touchUpInside
        )
        
        groupName = componentTitleLabel(componentTitle: "그룹명")
        groupNameTextField.delegate = self
        groupNameTextField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                viewModel.updateGroupName(groupName: groupNameTextField.text)
                groupNameTextField.text = viewModel.currentGroupName
                groupNameCountLabel.text = String(viewModel.currentGroupName.count)
                completeButton.setButtonStatus(status: viewModel.currentStep == .one && viewModel.currentGroupName.count > 0 ? .enabled : .disabled)
            }, for: .editingChanged
        )
        groupNameMaxLengthLabel.text = "/\(viewModel.groupNameMaxLength)"
        
        memberCount = componentTitleLabel(componentTitle: "그룹 인원")
        memberCountView = CounterView(min: 2, max: 20, current: viewModel.memberCount, unit: "명") { [weak self] in
            self?.viewModel.updateMemberCount(count: $0)
        }
        
        todoLimit = componentTitleLabel(componentTitle: "투두 개수")
        todoLimitView = CounterView(min: 2, max: 10, current: viewModel.todoLimit, unit: "개") { [weak self] in
            self?.viewModel.updateTodoLimit(count: $0)
        }
        
        duration = componentTitleLabel(componentTitle: "기간")
        [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    updateDuration(button.duration)
                }, for: .touchUpInside
            )
        }
        durationRow1 = horizontalStackView(buttons: [threeDaysButton, oneWeekButton])
        durationRow2 = horizontalStackView(buttons: [twoWeeksButton, fourWeeksButton])
        durationStack = verticalStackView(stacks: [durationRow1, durationRow2])
        
        startAt = componentTitleLabel(componentTitle: "시작일")
        [todayButton, tomorrowButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    updateStartAt(button.startAt)
                }, for: .touchUpInside
            )
        }
        startAtStack = horizontalStackView(buttons: [todayButton, tomorrowButton])
    }
    
    override func configureHierarchy() {
        [ dogetherHeader, stepLabelStackView, stepDescriptionLabel, completeButton,
          stepOneView, stepTwoView, stepThreeView, stepFourView
        ].forEach { view.addSubview($0) }
        
        [ groupName, groupNameView, groupNameTextField, groupNameCountLabel, groupNameMaxLengthLabel,
          memberCount, memberCountView
        ].forEach { stepOneView.addSubview($0) }
        
        [todoLimit, todoLimitView].forEach { stepTwoView.addSubview($0) }
        
        [duration, durationStack, startAt, startAtStack].forEach { stepThreeView.addSubview($0) }
        
        [dogetherGroupInfo].forEach { stepFourView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        stepLabelStackView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(56)
            $0.left.equalToSuperview().inset(16)
            $0.width.equalTo(24 * 4 + 8 * 3)
            $0.height.equalTo(24)
        }
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepOne.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // MARK: - stepOne
        stepOneView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(memberCountView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        groupName.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        groupNameView.snp.makeConstraints {
            $0.top.equalTo(groupName.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        groupNameTextField.snp.makeConstraints {
            $0.centerY.equalTo(groupNameView)
            $0.left.equalTo(groupNameView).inset(16)
            $0.right.equalTo(groupNameCountLabel.snp.left)
            $0.height.equalTo(25)
        }
        groupNameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(groupNameView)
            $0.right.equalTo(groupNameMaxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        groupNameMaxLengthLabel.snp.makeConstraints {
            $0.centerY.equalTo(groupNameView)
            $0.right.equalTo(groupNameView).inset(16)
            $0.height.equalTo(18)
        }
        memberCount.snp.makeConstraints {
            $0.top.equalTo(groupNameView.snp.bottom).offset(20)
        }
        memberCountView.snp.makeConstraints {
            $0.top.equalTo(memberCount.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(79)
        }
        
        // MARK: - stepTwo
        stepTwoView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(todoLimitView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        todoLimit.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        todoLimitView.snp.makeConstraints {
            $0.top.equalTo(todoLimit.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(79)
        }
        
        // MARK: - stepThree
        stepThreeView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(startAtStack.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        duration.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        durationStack.snp.makeConstraints {
            $0.top.equalTo(duration.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(108)
        }
        startAt.snp.makeConstraints {
            $0.top.equalTo(durationStack.snp.bottom).offset(30)
        }
        startAtStack.snp.makeConstraints {
            $0.top.equalTo(startAt.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(166)
        }
        
        // MARK: - stepFour
        stepFourView.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(34)
            $0.bottom.equalTo(dogetherGroupInfo.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(36)
        }
        dogetherGroupInfo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(267)
        }
    }
}

// MARK: - update UI
extension GroupCreateViewController {
    private func updateStep() {
        [stepOne, stepTwo, stepThree, stepFour].forEach {
            guard let step = CreateGroupSteps(rawValue: $0.tag) else { return }
            $0.textColor = viewModel.currentStep == step ? .grey900 : .grey300
            $0.backgroundColor = viewModel.currentStep == step ? .blue100 : .grey700
        }
        
        [stepOneView, stepTwoView, stepThreeView, stepFourView].forEach {
            guard let step = CreateGroupSteps(rawValue: $0.tag) else { return }
            $0.isHidden = viewModel.currentStep != step
        }
        
        stepDescriptionLabel.text = viewModel.currentStep.description
        if viewModel.currentStep == .two { view.endEditing(true) }
        if viewModel.currentStep == .three { completeButton.setTitle("그룹 생성") }
        if viewModel.currentStep == .four {
            dogetherGroupInfo.setInfo(
                groupName: viewModel.currentGroupName,
                memberCount: viewModel.memberCount,
                duration: viewModel.currentDuration,
                startAt: viewModel.currentStartAt
            )
        }
    }
    
    private func updateDuration(_ duration: GroupChallengeDurations = .threeDays) {
        viewModel.updateDuration(duration: duration)
        
        [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach {
            $0.setColorful(isColorful: viewModel.currentDuration == $0.duration)
        }
    }
    
    private func updateStartAt(_ startAt: GroupStartAts = .today) {
        viewModel.updateStartAt(startAt: startAt)
        
        [todayButton, tomorrowButton].forEach {
            $0.setColorful(isColorful: viewModel.currentStartAt == $0.startAt)
        }
    }
}

// MARK: - abount keyboard
extension GroupCreateViewController: UITextFieldDelegate {
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        groupNameView.layer.borderColor = UIColor.blue300.cgColor
        groupNameCountLabel.textColor = .blue300
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        groupNameView.layer.borderColor = UIColor.grey800.cgColor
        groupNameCountLabel.textColor = .grey300
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
