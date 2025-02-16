//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    private var viewModel = MainViewModel(status: .todoList)
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    private let groupNameLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.emphasis2B
        return label
    }()
    private var joinCodeDescriptionLabel = UILabel()
    private var endDateDescriptionLabel = UILabel()
    private var joinCodeInfoLabel = UILabel()
    private var endDateInfoLabel = UILabel()
    private var joinCodeStackView = UIStackView()
    private var endDateStackView = UIStackView()
    private func mainInfoStackView(stackViews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stackViews)
        stackView.axis = .horizontal
        stackView.spacing = 28
        return stackView
    }
    private var mainInfoStackView = UIStackView()
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        return button
    }()
    private let rankingImageView = {
        let imageView = UIImageView()
        imageView.image = .chart
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private let rankingLabel = {
        let label = UILabel()
        label.text = "순위 보러가기 !"
        label.textColor = .grey100
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        return label
    }()
    private let rankingChevronImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey100
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private let dogetherSheet = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private let dogetherSheetHeaderLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private func dogetherContentView(status: MainViewStatus) -> UIView {
        let view = UIView()
        view.tag = status.rawValue
        view.isHidden = viewModel.mainViewStatus != status
        return view
    }
    private let dogetherScrollView = UIScrollView()
    private var beforeStartView = UIView()
    private var emptyListView = UIView()
    private var todoListView = UIView()
    private let timerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 142 / 2
        return view
    }()
    private let timerInfoView = UIView()
    private var timeProgress = UIView()
    private let timeProgressLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue300.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        return shapeLayer
    }()
    private let timerImageView = {
        let imageView = UIImageView()
        imageView.image = .wait.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue300
        return imageView
    }()
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    private let beforeStartTitleLabel = {
        let label = UILabel()
        label.text = "내일부터 투두를 시작할 수 있어요!"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let beforeStartSubTitleLabel = {
        let label = UILabel()
        label.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    private let todoImageView = {
        let imageView = UIImageView()
        imageView.image = .todo
        return imageView
    }()
    private let todoTitleLabel = {
        let label = UILabel()
        label.text = "오늘의 투두를 작성해보세요"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let todoSubTitleLabel = {
        let label = UILabel()
        label.text = "매일 자정부터 새로운 투두를 입력해요"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    private let todoButton = DogetherButton(action: {
        // TODO: 추후 투두 작성하기로 이동하도록 구현
    }, title: "투두 작성하기", status: .enabled)
    private func filterButton(type: FilterTypes) -> UIButton {
        let button = UIButton()
        button.backgroundColor = viewModel.currentFilter == type ? type.backgroundColor : .grey800
        button.layer.cornerRadius = 16
        button.layer.borderColor = viewModel.currentFilter == type ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        button.layer.borderWidth = 1
        button.tag = type.tag
        return button
    }
    private var allButton = UIButton()
    private var waitButton = UIButton()
    private var rejectButton = UIButton()
    private var approveButton = UIButton()
    private func filterLabel(type: FilterTypes) -> UILabel {
        let label = UILabel()
        label.text = type.rawValue
        label.textColor = viewModel.currentFilter == type ? .grey900 : .grey400
        label.font = Fonts.body2S
        label.tag = type.tag
        return label
    }
    private var allLabel = UILabel()
    private var waitLabel = UILabel()
    private var rejectLabel = UILabel()
    private var approveLabel = UILabel()
    private func filterImageView(type: FilterTypes) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = type.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = viewModel.currentFilter == type ? .grey900 : .grey400
        imageView.tag = type.tag
        return imageView
    }
    private var waitImageView = UIImageView()
    private var rejectImageView = UIImageView()
    private var approveImageView = UIImageView()
    private func filterButtonStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    private var filterStackView = UIStackView()
    private func todoItemStackView(items: [DogetherTodoItem]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }
    private var todoListStackView = UIStackView()
    
    override func viewDidLoad() {
        // TODO: 추후 API 연동하면서 위치 와 방법 수정
        viewModel.setTodoList(
            [
                TodoInfo(id: 0, content: "인증도 안한 투두", status: .waitCertificattion),
                TodoInfo(id: 1, content: "인증한 투두", status: .waitExamination),
                TodoInfo(id: 2, content: "노인정 투두", status: .reject),
                TodoInfo(id: 3, content: "인정 투두", status: .approve),
                TodoInfo(id: 0, content: "인증도 안한 투두", status: .waitCertificattion),
                TodoInfo(id: 1, content: "인증한 투두", status: .waitExamination),
                TodoInfo(id: 2, content: "노인정 투두", status: .reject),
                TodoInfo(id: 3, content: "인정 투두", status: .approve),
                TodoInfo(id: 0, content: "인증도 안한 투두", status: .waitCertificattion),
                TodoInfo(id: 1, content: "인증한 투두", status: .waitExamination),
                TodoInfo(id: 2, content: "노인정 투두", status: .reject),
                TodoInfo(id: 3, content: "인정 투두", status: .approve)
            ]
        )
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        timeProgress.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: timeProgress.bounds.width / 2, y: timeProgress.bounds.height / 2),
            radius: (timeProgress.bounds.width - 6) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        timeProgressLayer.path = circlePath.cgPath
        timeProgressLayer.strokeEnd = viewModel.timeProgress
        timeProgress.layer.addSublayer(timeProgressLayer)
    }
    
    override func configureView() {
        groupNameLabel.text = viewModel.groupName
        
        joinCodeDescriptionLabel.attributedText = NSAttributedString(
            string: "초대코드",
            attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
        )
        joinCodeDescriptionLabel.textColor = .grey300
        endDateDescriptionLabel.attributedText = NSAttributedString(
            string: "종료일",
            attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
        )
        endDateDescriptionLabel.textColor = .grey300
        joinCodeInfoLabel.attributedText = NSAttributedString(
            string: viewModel.joinCode,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        joinCodeInfoLabel.textColor = .grey0
        endDateInfoLabel.attributedText = NSAttributedString(
            string: "\(DateFormatterManager.formattedDate(viewModel.restDay))(D-\(viewModel.restDay))",
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        endDateInfoLabel.textColor = .grey0
        joinCodeStackView = UIStackView(arrangedSubviews: [joinCodeDescriptionLabel, joinCodeInfoLabel])
        joinCodeStackView.axis = .vertical
        endDateStackView = UIStackView(arrangedSubviews: [endDateDescriptionLabel, endDateInfoLabel])
        endDateStackView.axis = .vertical
        mainInfoStackView = mainInfoStackView(stackViews: [joinCodeStackView, endDateStackView])
        
        rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        dogetherSheetHeaderLabel.text = DateFormatterManager.formattedDate()
        
        dogetherScrollView.delegate = self
        dogetherScrollView.bounces = false
        dogetherScrollView.showsVerticalScrollIndicator = false
        
        beforeStartView = dogetherContentView(status: .beforeStart)
        emptyListView = dogetherContentView(status: .emptyList)
        todoListView = dogetherContentView(status: .todoList)
        
        timerLabel.text = viewModel.time
        
        allButton = filterButton(type: .all)
        waitButton = filterButton(type: .wait)
        rejectButton = filterButton(type: .reject)
        approveButton = filterButton(type: .approve)
        allButton.addTarget(self, action: #selector(didTapFilterButton(_:)), for: .touchUpInside)
        waitButton.addTarget(self, action: #selector(didTapFilterButton(_:)), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(didTapFilterButton(_:)), for: .touchUpInside)
        approveButton.addTarget(self, action: #selector(didTapFilterButton(_:)), for: .touchUpInside)
        allLabel = filterLabel(type: .all)
        waitLabel = filterLabel(type: .wait)
        rejectLabel = filterLabel(type: .reject)
        approveLabel = filterLabel(type: .approve)
        waitImageView = filterImageView(type: .wait)
        rejectImageView = filterImageView(type: .reject)
        approveImageView = filterImageView(type: .approve)
        filterStackView = filterButtonStackView(buttons: [allButton, waitButton, rejectButton, approveButton])
        todoListStackView = todoItemStackView(
            items: viewModel.todoList.map { todo in
                DogetherTodoItem(action: {
                    if todo.status == .waitCertificattion {
                        PopupManager.shared.showPopup(type: .certification)
                    } else {
                        // TODO: 추후 인증정보 팝업을 띄우도록 구현
                    }
                }, todo: todo)
            }
        )
    }
    
    override func configureHierarchy() {
        [
            dogetherHeader, groupNameLabel, mainInfoStackView,
            rankingButton, rankingImageView, rankingLabel, rankingChevronImageView,
            dogetherSheet
        ].forEach { view.addSubview($0) }
        
        [dogetherSheetHeaderLabel, beforeStartView, emptyListView].forEach { dogetherSheet.addSubview($0) }
        [
            timerView, timerInfoView, timeProgress, timerImageView, timerLabel,
            beforeStartTitleLabel, beforeStartSubTitleLabel
        ].forEach { beforeStartView.addSubview($0) }
        [todoImageView, todoTitleLabel, todoSubTitleLabel, todoButton].forEach { emptyListView.addSubview($0) }
        
        [
            filterStackView, allLabel, waitLabel, rejectLabel, approveLabel,
            waitImageView, rejectImageView, approveImageView, dogetherScrollView
        ].forEach { dogetherSheet.addSubview($0) }
        [todoListView].forEach { dogetherScrollView.addSubview($0) }
        [todoListStackView].forEach { todoListView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        mainInfoStackView.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(16)
            $0.left.equalTo(groupNameLabel)
        }
        
        rankingButton.snp.makeConstraints {
            $0.top.equalTo(mainInfoStackView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        rankingImageView.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.left.equalTo(rankingButton).offset(16)
            $0.width.height.equalTo(24)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.left.equalTo(rankingImageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        rankingChevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.right.equalTo(rankingButton).offset(-16)
            $0.width.height.equalTo(22)
        }
        
        dogetherSheet.snp.makeConstraints {
            dogetherSheetTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).offset(SheetStatus.normal.offset).constraint
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dogetherSheetHeaderLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogetherSheet).offset(24)
            $0.height.equalTo(28)
        }
        
        // MARK: - beforeStart
        beforeStartView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(142)
        }
        
        timeProgress.snp.makeConstraints {
            $0.edges.equalTo(timerView)
        }
        
        timerInfoView.snp.makeConstraints {
            $0.center.equalTo(timerView)
            $0.height.equalTo(58)
        }
        
        timerImageView.snp.makeConstraints {
            $0.centerX.equalTo(timerInfoView)
            $0.top.equalTo(timerInfoView)
            $0.width.height.equalTo(20)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerInfoView)
            $0.bottom.equalTo(timerInfoView)
            $0.height.equalTo(36)
        }
        
        beforeStartTitleLabel.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        beforeStartSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(beforeStartTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        // MARK: - emptyList
        emptyListView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        
        todoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(202)
            $0.height.equalTo(131)
        }
        
        todoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        todoSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        todoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        // MARK: - todoList
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        
        // TODO: 추후 개선
        allButton.snp.makeConstraints {
            $0.width.equalTo(FilterTypes.all.width)
        }
        
        waitButton.snp.makeConstraints {
            $0.width.equalTo(FilterTypes.wait.width)
        }
        
        rejectButton.snp.makeConstraints {
            $0.width.equalTo(FilterTypes.reject.width)
        }
        
        approveButton.snp.makeConstraints {
            $0.width.equalTo(FilterTypes.approve.width)
        }
        
        allLabel.snp.makeConstraints {
            $0.center.equalTo(allButton)
        }
        
        waitLabel.snp.makeConstraints {
            $0.centerX.equalTo(waitButton).offset(13)
            $0.centerY.equalTo(waitButton)
        }
        
        rejectLabel.snp.makeConstraints {
            $0.centerX.equalTo(rejectButton).offset(13)
            $0.centerY.equalTo(rejectButton)
        }
        
        approveLabel.snp.makeConstraints {
            $0.centerX.equalTo(approveButton).offset(13)
            $0.centerY.equalTo(approveButton)
        }
        
        waitImageView.snp.makeConstraints {
            $0.left.equalTo(waitButton).offset(8)
            $0.centerY.equalTo(waitButton)
            $0.width.height.equalTo(24)
        }
        
        rejectImageView.snp.makeConstraints {
            $0.left.equalTo(rejectButton).offset(8)
            $0.centerY.equalTo(rejectButton)
            $0.width.height.equalTo(24)
        }
        
        approveImageView.snp.makeConstraints {
            $0.left.equalTo(approveButton).offset(8)
            $0.centerY.equalTo(approveButton)
            $0.width.height.equalTo(24)
        }
        
        dogetherScrollView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(28)
            $0.bottom.left.right.equalToSuperview()
        }
        
        todoListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(dogetherScrollView)
            $0.height.equalTo(viewModel.todoListHeight)
        }
        
        todoListStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(viewModel.todoListHeight)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if viewModel.isBlockPanGesture { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 0 {
                    dogetherSheetTopConstraint?.update(offset: min(SheetStatus.normal.offset, translation.y))
                    view.layoutIfNeeded()
                }
            case .normal:
                if translation.y < 0 {
                    dogetherSheetTopConstraint?.update(offset: max(0, SheetStatus.normal.offset + translation.y))
                    view.layoutIfNeeded()
                }
            }
            
        case .ended:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 100 { updateSheetStatus(to: .normal) }
                else { updateSheetStatus(to: .expand) }
            case .normal:
                if translation.y < -100 { updateSheetStatus(to: .expand) }
                else { updateSheetStatus(to: .normal) }
            }
            
        default:
            break
        }
    }
    
    private func updateSheetStatus(to status: SheetStatus) {
        viewModel.setIsBlockPanGesture(true)
        UIView.animate(withDuration: 0.3) {
            self.dogetherSheetTopConstraint?.update(offset: status.offset)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel.setIsBlockPanGesture(false)
            self.viewModel.updateSheetStatus(status)
        }
    }
    
    @objc private func didTapRankingButton() {
        NavigationManager.shared.pushViewController(RankingViewController())
    }
    
    @objc private func didTapFilterButton(_ sender: UIButton) {
        guard let filterType = FilterTypes.allCases.first(where: { $0.tag == sender.tag }) else { return }
        viewModel.updateFilter(filterType)
        updateTodoList()
    }
    
    private func updateTodoList() {
        [allButton, waitButton, rejectButton, approveButton].forEach { button in
            guard let type = FilterTypes.allCases.first(where: { $0.tag == button.tag }) else { return }
            button.backgroundColor = viewModel.currentFilter == type ? type.backgroundColor : .grey800
            button.layer.borderColor = viewModel.currentFilter == type ? type.backgroundColor.cgColor : UIColor.grey500.cgColor
        }
        [allLabel, waitLabel, rejectLabel, approveLabel].forEach { label in
            guard let type = FilterTypes.allCases.first(where: { $0.tag == label.tag }) else { return }
            label.textColor = viewModel.currentFilter == type ? .grey900 : .grey400
        }
        [waitImageView, rejectImageView, approveImageView].forEach { imageView in
            guard let type = FilterTypes.allCases.first(where: { $0.tag == imageView.tag }) else { return }
            imageView.tintColor = viewModel.currentFilter == type ? .grey900 : .grey400
        }
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && dogetherScrollView.contentOffset.y > 0 { return false }
        return true
    }
}

// MARK: - about scroll
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.panGestureRecognizer.isEnabled = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal || viewModel.isBlockPanGesture {
            scrollView.contentOffset.y = 0
            return
        }
    }
}
