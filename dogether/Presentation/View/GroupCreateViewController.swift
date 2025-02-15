//
//  GroupCreateViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import Foundation
import UIKit
import SnapKit

final class GroupCreateViewController: BaseViewController {
    private var viewModel = GroupCreateViewModel()
    
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
    private var stepLabelStack = UIStackView()
    private func descriptionLabel(step: CreateGroupSteps) -> UILabel {
        let label = UILabel()
        label.text = step.description
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }
    private var stepDescriptionLabel = UILabel()
    private let completeButton = DogetherButton(action: { }, title: "다음", status: .disabled)
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
        label.textColor = .grey300
        label.font = Fonts.smallS
        return label
    }()
    private var memberCountView = UIView()
    private var todoLimitView = UIView()
    private func durationButton(duration: GroupChallengeDurations) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        button.layer.borderColor = viewModel.currentDuration == duration ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        button.layer.borderWidth = 1.5
        button.tag = duration.rawValue
        button.addTarget(self, action: #selector(didTapDurationButton(_:)), for: .touchUpInside)
        return button
    }
    private func durationLabel(duration: GroupChallengeDurations) -> UILabel {
        let label = UILabel()
        label.text = duration.text
        label.textColor = viewModel.currentDuration == duration ? .blue300 : .grey0
        label.font = viewModel.currentDuration == duration ? Fonts.body1B : Fonts.body1S
        label.textAlignment = .left
        label.tag = duration.rawValue
        return label
    }
    private var threeDaysButton = UIButton()
    private var oneWeekButton = UIButton()
    private var twoWeeksButton = UIButton()
    private var fourWeeksButton = UIButton()
    private var threeDaysLabel = UILabel()
    private var oneWeekLabel = UILabel()
    private var twoWeeksLabel = UILabel()
    private var fourWeeksLabel = UILabel()
    private func horizontalStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private func verticalStackView(stacks: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stacks)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var durationRow1 = UIStackView()
    private var durationRow2 = UIStackView()
    private var durationStack = UIStackView()
    private func startAtButton(startAt: GroupStartAts) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey800
        button.layer.cornerRadius = 12
        button.layer.borderColor = viewModel.currentStartAt == startAt ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        button.layer.borderWidth = 1.5
        button.tag = startAt.daysFromToday
        button.addTarget(self, action: #selector(didTapStartAtButton(_:)), for: .touchUpInside)
        return button
    }
    private var todayButton = UIButton()
    private var tomorrowButton = UIButton()
    private var startAtStack = UIStackView()
    private func startAtImageView(startAt: GroupStartAts) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .today.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = viewModel.currentStartAt == startAt ? .blue300 : .grey0
        imageView.isUserInteractionEnabled = false
        imageView.tag = startAt.daysFromToday
        return imageView
    }
    private var todayImageView = UIImageView()
    private var tomorrowImageView = UIImageView()
    private func startAtTextLabel(startAt: GroupStartAts) -> UILabel {
        let label = UILabel()
        label.text = startAt.text + "시작"
        label.textColor = viewModel.currentStartAt == startAt ? .blue300 : .grey0
        label.font = Fonts.body1B
        label.tag = startAt.daysFromToday
        return label
    }
    private var todayLabel = UILabel()
    private var tomorrowLabel = UILabel()
    private func startAtDescriptionLabel(startAt: GroupStartAts) -> UILabel {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: startAt.description,
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .left)
        )
        label.textColor = viewModel.currentStartAt == startAt ? .blue300 : .grey0
        label.numberOfLines = 0
        label.tag = startAt.daysFromToday
        return label
    }
    private var todayDescriptionLabel = UILabel()
    private var tomorrowDescriptionLabel = UILabel()
    private let dogetherGroupInfo = DogetherGroupInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func configureView() {
        stepOne = stepLabel(step: .one)
        stepTwo = stepLabel(step: .two)
        stepThree = stepLabel(step: .three)
        stepFour = stepLabel(step: .four)
        stepLabelStack = stepLabelStackView(labels: [stepOne, stepTwo, stepThree, stepFour])
        
        stepDescriptionLabel = descriptionLabel(step: viewModel.currentStep)
        
        stepOneView = stepView(step: .one)
        stepTwoView = stepView(step: .two)
        stepThreeView = stepView(step: .three)
        stepFourView = stepView(step: .four)
        
        completeButton.action = { @MainActor in
            if self.viewModel.currentStep == .four {
                NavigationManager.shared.setNavigationController(CompleteViewController(type: .create))
            } else {
                await self.viewModel.completeAction()
                self.updateStep()
            }
        }
        
        groupName = componentTitleLabel(componentTitle: "그룹명")
        groupNameTextField.delegate = self
        groupNameTextField.addTarget(self, action: #selector(didChangeGroupName), for: .editingChanged)
        groupNameCountLabel.text = "0/\(viewModel.groupNameMaxLength)"
        memberCount = componentTitleLabel(componentTitle: "그룹 인원")
        memberCountView = DogetherCountView(changeCountAction: {
            self.viewModel.updateMemberCount(count: $0)
        }, min: 2, max: 20, current: viewModel.memberCount, unit: "명")
        
        todoLimit = componentTitleLabel(componentTitle: "투두 개수")
        todoLimitView = DogetherCountView(changeCountAction: {
            self.viewModel.updateTodoLimit(count: $0)
        }, min: 2, max: 10, current: viewModel.todoLimit, unit: "개")
        duration = componentTitleLabel(componentTitle: "기간")
        startAt = componentTitleLabel(componentTitle: "시작일")
        
        threeDaysButton = durationButton(duration: .threeDays)
        oneWeekButton = durationButton(duration: .oneWeek)
        twoWeeksButton = durationButton(duration: .twoWeeks)
        fourWeeksButton = durationButton(duration: .fourWeeks)
        threeDaysLabel = durationLabel(duration: .threeDays)
        oneWeekLabel = durationLabel(duration: .oneWeek)
        twoWeeksLabel = durationLabel(duration: .twoWeeks)
        fourWeeksLabel = durationLabel(duration: .fourWeeks)
        durationRow1 = horizontalStackView(buttons: [threeDaysButton, oneWeekButton])
        durationRow2 = horizontalStackView(buttons: [twoWeeksButton, fourWeeksButton])
        durationStack = verticalStackView(stacks: [durationRow1, durationRow2])
        todayButton = startAtButton(startAt: .today)
        tomorrowButton = startAtButton(startAt: .tomorrow)
        startAtStack = horizontalStackView(buttons: [todayButton, tomorrowButton])
        todayImageView = startAtImageView(startAt: .today)
        tomorrowImageView = startAtImageView(startAt: .tomorrow)
        todayLabel = startAtTextLabel(startAt: .today)
        tomorrowLabel = startAtTextLabel(startAt: .tomorrow)
        todayDescriptionLabel = startAtDescriptionLabel(startAt: .today)
        tomorrowDescriptionLabel = startAtDescriptionLabel(startAt: .tomorrow)
    }
    
    override func configureHierarchy() {
        [
            dogetherHeader, stepLabelStack, stepDescriptionLabel, completeButton,
            stepOneView, stepTwoView, stepThreeView, stepFourView
        ].forEach { view.addSubview($0) }
        
        [
            groupName, groupNameView, groupNameTextField, groupNameCountLabel,
            memberCount, memberCountView
        ].forEach { stepOneView.addSubview($0) }
        
        [todoLimit, todoLimitView].forEach { stepTwoView.addSubview($0) }
        
        [
            duration, durationStack, threeDaysLabel, oneWeekLabel, twoWeeksLabel, fourWeeksLabel,
            startAt, startAtStack,
            todayImageView, tomorrowImageView, todayLabel, tomorrowLabel, todayDescriptionLabel, tomorrowDescriptionLabel
        ].forEach { stepThreeView.addSubview($0) }
        
        [dogetherGroupInfo].forEach { stepFourView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        stepLabelStack.snp.makeConstraints {
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
            $0.bottom.equalToSuperview().inset(48)
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
            $0.width.equalToSuperview()
            $0.height.equalTo(108)
        }
        threeDaysLabel.snp.makeConstraints {
            $0.centerY.equalTo(threeDaysButton)
            $0.left.equalTo(threeDaysButton).inset(16)
        }
        oneWeekLabel.snp.makeConstraints {
            $0.centerY.equalTo(oneWeekButton)
            $0.left.equalTo(oneWeekButton).inset(16)
        }
        twoWeeksLabel.snp.makeConstraints {
            $0.centerY.equalTo(twoWeeksButton)
            $0.left.equalTo(twoWeeksButton).inset(16)
        }
        fourWeeksLabel.snp.makeConstraints {
            $0.centerY.equalTo(fourWeeksButton)
            $0.left.equalTo(fourWeeksButton).inset(16)
        }
        startAt.snp.makeConstraints {
            $0.top.equalTo(durationStack.snp.bottom).offset(30)
        }
        startAtStack.snp.makeConstraints {
            $0.top.equalTo(startAt.snp.bottom).offset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(166)
        }
        todayImageView.snp.makeConstraints {
            $0.top.equalTo(todayButton).offset(26)
            $0.left.equalTo(todayButton).inset(20)
            $0.width.height.equalTo(24)
        }
        tomorrowImageView.snp.makeConstraints {
            $0.top.equalTo(tomorrowButton).offset(26)
            $0.left.equalTo(tomorrowButton).inset(20)
            $0.width.height.equalTo(24)
        }
        todayLabel.snp.makeConstraints {
            $0.top.equalTo(todayImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(todayButton).inset(20)
            $0.height.equalTo(25)
        }
        tomorrowLabel.snp.makeConstraints {
            $0.top.equalTo(tomorrowImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(tomorrowButton).inset(20)
            $0.height.equalTo(25)
        }
        todayDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(todayButton).inset(27)
            $0.horizontalEdges.equalTo(todayButton).inset(20)
        }
        tomorrowDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tomorrowLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(tomorrowButton).inset(27)
            $0.horizontalEdges.equalTo(tomorrowButton).inset(20)
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
    
    @objc private func didChangeGroupName() {
        if let text = groupNameTextField.text, text.count > viewModel.groupNameMaxLength {
            groupNameTextField.text = String(text.prefix(viewModel.groupNameMaxLength))
        }
        
        Task { @MainActor in
            let (groupName, countLabelText, buttonStatus) = await viewModel.updateGroupName(groupName: groupNameTextField.text)
            groupNameTextField.text = groupName
            groupNameCountLabel.text = countLabelText
            completeButton.setButtonStatus(status: buttonStatus)
        }
    }
    
    @objc private func didTapDurationButton(_ sender: UIButton) {
        guard let duration = GroupChallengeDurations(rawValue: sender.tag) else { return }
        
        Task { @MainActor in
            await viewModel.updateDuration(duration: duration)
            updateDuration()
        }
    }
    
    private func updateDuration() {
        [threeDaysButton, oneWeekButton, twoWeeksButton, fourWeeksButton].forEach {
            guard let duration = GroupChallengeDurations(rawValue: $0.tag) else { return }
            $0.layer.borderColor = viewModel.currentDuration == duration ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        }
        [threeDaysLabel, oneWeekLabel, twoWeeksLabel, fourWeeksLabel].forEach {
            guard let duration = GroupChallengeDurations(rawValue: $0.tag) else { return }
            $0.textColor = viewModel.currentDuration == duration ? .blue300 : .grey0
            $0.font = viewModel.currentDuration == duration ? Fonts.body1B : Fonts.body1S
        }
    }
    
    @objc private func didTapStartAtButton(_ sender: UIButton) {
        guard let startAt = GroupStartAts.allCases.first(where: { $0.daysFromToday == sender.tag }) else { return }
        
        Task { @MainActor in
            await viewModel.updateStartAt(startAt: startAt)
            updateStartAt()
        }
    }
    
    private func updateStartAt() {
        [todayButton, tomorrowButton].forEach { button in
            guard let startAt = GroupStartAts.allCases.first(where: { $0.daysFromToday == button.tag }) else { return }
            button.layer.borderColor = viewModel.currentStartAt == startAt ? UIColor.blue300.cgColor : UIColor.grey800.cgColor
        }
        [todayImageView, tomorrowImageView].forEach { imageView in
            guard let startAt = GroupStartAts.allCases.first(where: { $0.daysFromToday == imageView.tag }) else { return }
            imageView.tintColor = viewModel.currentStartAt == startAt ? .blue300 : .grey0
        }
        [todayLabel, tomorrowLabel, todayDescriptionLabel, tomorrowDescriptionLabel].forEach { label in
            guard let startAt = GroupStartAts.allCases.first(where: { $0.daysFromToday == label.tag }) else { return }
            label.textColor = viewModel.currentStartAt == startAt ? .blue300 : .grey0
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        completeButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardFrame.cgRectValue.height + 16)
        }
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        completeButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(48)
        }
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
