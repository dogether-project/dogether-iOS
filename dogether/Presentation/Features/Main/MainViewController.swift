//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    var viewModel = MainViewModel()
    
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    
    private let dosikImageView = UIImageView(image: .noteDosik)
    
    private let groupInfoView = GroupInfoView()
    
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: .chart)
        imageView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = "그룹 활동 한눈에 보기 !"
        label.textColor = .grey100
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = .grey100
        chevronImageView.isUserInteractionEnabled = false
        
        [imageView, label, chevronImageView].forEach { button.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(22)
        }
        
        return button
    }()
    
    private let dogetherSheet = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let sheetHeaderView = SheetHeaderView()
    
    private let beforeStartView = UIView()
    private let emptyListView = UIView()
    private let todoListView = UIView()
    
    private let timerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 142 / 2
        
        let imageView = UIImageView()
        imageView.image = .wait.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue300
        
        [imageView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        return view
    }()
    
    private let timeProgress = {
        let view = UIView()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue300.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        
        let viewSize: CGFloat = 142
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: viewSize / 2, y: viewSize / 2),
            radius: (viewSize - 6) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        shapeLayer.path = circlePath.cgPath
        view.layer.addSublayer(shapeLayer)
            
        return view
    }()
    
    private let timerLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head1B
        return label
    }()
    
    private let timerDescription = {
        let title = UILabel()
        title.text = "내일부터 투두를 시작할 수 있어요!"
        title.textColor = .grey0
        title.font = Fonts.head2B
        
        let subTitle = UILabel()
        subTitle.text = "오늘은 계획을 세우고, 내일부터 실천해보세요!"
        subTitle.textColor = .grey300
        subTitle.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [title, subTitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        title.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        subTitle.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        
        return stackView
    }()
    
    private let todoView = {
        let imageView = UIImageView(image: .todo)
        imageView.contentMode = .scaleAspectFit
        
        let title = UILabel()
        title.text = "오늘의 투두를 작성해보세요"
        title.textColor = .grey0
        title.font = Fonts.head2B
        
        let subTitle = UILabel()
        subTitle.text = "매일 자정부터 새로운 투두를 입력해요"
        subTitle.textColor = .grey300
        subTitle.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [imageView, title, subTitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.setCustomSpacing(10, after: imageView)
        stackView.setCustomSpacing(4, after: title)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.53)
            if let image = imageView.image {
                $0.height.equalTo(imageView.snp.width).multipliedBy(image.size.height / image.size.width)
            }
        }
        
        title.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        subTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        return stackView
    }()
    
    private let todoButton = DogetherButton(title: "투두 작성하기", status: .enabled)
    
    private let allButton = FilterButton(type: .all)
    private let waitButton = FilterButton(type: .wait)
    private let rejectButton = FilterButton(type: .reject)
    private let approveButton = FilterButton(type: .approve)
    
    private func filterStackView(buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    private var filterStackView = UIStackView()
    
    private let todoScrollView = UIScrollView()
    
    private let todoListStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // FIXME: 추후 메인 화면 작업 시 수정
    final class EmptyDescriptionView: UIView {
        private(set) var type: FilterTypes = .all
        
        private let imageView = UIImageView(image: .comment)
        
        private let label = UILabel()
        
        init() {
            super.init(frame: .zero)
            
            setUI()
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        private func updateUI() {
            label.text = type.emptyDescription
        }
        
        private func setUI() {
            updateUI()
            
            label.textColor = .grey400
            label.font = Fonts.head2B
            
            [imageView, label].forEach { self.addSubview($0) }
            
            imageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
                $0.width.equalTo(74)
                $0.height.equalTo(54)
            }
            
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(28)
            }
        }
        
        func setType(_ type: FilterTypes) {
            self.type = type
            
            updateUI()
        }
    }
    private var emptyDescriptionView = EmptyDescriptionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ???: 화면 전환을 고려하면 일부러 강한 참조를 걸어야할까
        // TODO: 알림 권한을 거부한 사용자에 대한 로직은 추후에 추가
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.checkAuthorization()
            
            let reviews = try await viewModel.getReviews()
            if reviews.isEmpty { return }
            
            await MainActor.run {
                self.coordinator?.showModal(reviews: reviews)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.loadMainView()
            await MainActor.run { self.updateView() }
            
            if viewModel.currentGroup.status == .ready {
                viewModel.startCountdown(updateTimer: updateTimer, updateList: updateList)
            } else {
                try await viewModel.updateListInfo()
                await MainActor.run { self.updateList() }
            }
        }
    }
    
    override func configureView() {
        filterStackView = filterStackView(buttons: [allButton, waitButton, rejectButton, approveButton])
    }
    
    override func configureAction() {
        dogetherHeader.delegate = self
        
        let groupNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGroupNameStackView))
        groupInfoView.groupNameStackView.addGestureRecognizer(groupNameTapGesture)
        
        rankingButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let rankingViewController = RankingViewController()
                rankingViewController.viewModel.groupId = 0 // FIXME: API 수정 후 반영
                coordinator?.pushViewController(rankingViewController)
            }, for: .touchUpInside
        )
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        [sheetHeaderView.prevButton, sheetHeaderView.nextButton].forEach { button in
            button.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let newOffset = viewModel.dateOffset + button.tag
                    viewModel.setDateOffset(offset: newOffset)
                    updateView()
                    // TODO: 확인 필요
                }, for: .touchUpInside
            )
        }
        
        todoScrollView.delegate = self
        todoScrollView.bounces = false
        todoScrollView.showsVerticalScrollIndicator = false
        
        todoButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.pushViewController(TodoWriteViewController())
            }, for: .touchUpInside
        )
        
        [allButton, waitButton, rejectButton, approveButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    Task {
                        self.viewModel.updateFilter(filter: button.type)
                        try await self.viewModel.updateListInfo()
                        await MainActor.run { self.updateList() }
                    }
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [dogetherHeader, dosikImageView, groupInfoView, rankingButton, dogetherSheet].forEach { view.addSubview($0) }
        
        [sheetHeaderView, beforeStartView, emptyListView, todoListView].forEach { dogetherSheet.addSubview($0) }
        
        [timerView, timeProgress, timerLabel, timerDescription,].forEach { beforeStartView.addSubview($0) }
        
        [todoView, todoButton].forEach { emptyListView.addSubview($0) }
        
        [todoScrollView, filterStackView, emptyDescriptionView].forEach { todoListView.addSubview($0) }
        [todoListStackView].forEach { todoScrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        dosikImageView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom)
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(120)
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36 + 12 + 45 + 16 + 21)   // FIXME: GroupInfoView 자체를 StackView로 전환
        }
        
        rankingButton.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        dogetherSheet.snp.makeConstraints {
            dogetherSheetTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).offset(SheetStatus.normal.offset).constraint
            $0.bottom.left.right.equalToSuperview()
        }
        
        sheetHeaderView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheet).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        // MARK: - beforeStart
        beforeStartView.snp.makeConstraints {
            $0.top.equalTo(sheetHeaderView.snp.bottom).offset(24)
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
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalTo(timerView)
            $0.centerY.equalTo(timerView).offset(11)
            $0.height.equalTo(36)
        }
        
        timerDescription.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        // MARK: - emptyList
        emptyListView.snp.makeConstraints {
            $0.top.equalTo(sheetHeaderView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
        todoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-49)
        }
        
        todoButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // MARK: - todoList
        todoListView.snp.makeConstraints {
            $0.top.equalTo(sheetHeaderView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(16)
        }
        
        todoScrollView.snp.makeConstraints {
            $0.top.equalTo(filterStackView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        todoListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // MARK: item 대신 stackView에서 너비 지정
        }
        
        emptyDescriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(filterStackView.snp.bottom).offset(125)
            $0.width.equalTo(233)
            $0.height.equalTo(98)
        }
    }
}

// MARK: - update UI
extension MainViewController {
    private func updateSheet(_ status: SheetStatus) {
        viewModel.setIsBlockPanGesture(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            dogetherSheetTopConstraint?.update(offset: status.offset)
            updateAlpha(alpha: status == .normal ? 1 : 0)
            view.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self else { return }
            viewModel.setIsBlockPanGesture(false)
        }
    }
    
    private func updateAlpha(alpha: CGFloat) {
        [dosikImageView, groupInfoView.groupInfoStackView, groupInfoView.durationStackView, rankingButton].forEach {
            $0.alpha = alpha
        }
    }
    
    private func updateView() {
        groupInfoView.setChallengeGroupInfo(challengeGroupInfo: viewModel.challengeGroupInfos[viewModel.currentChallengeIndex])
        
        sheetHeaderView.setDate(date: DateFormatterManager.formattedDate(viewModel.dateOffset))
        
        beforeStartView.isHidden = !(viewModel.currentGroup.status == .ready)
        emptyListView.isHidden = !(viewModel.currentGroup.status == .running && viewModel.todoList.isEmpty)
        todoListView.isHidden = !(viewModel.currentGroup.status == .running && viewModel.todoList.count > 0)
    }
    
    private func updateTimer() {
        timerLabel.text = viewModel.time
        (timeProgress.layer.sublayers?.first as? CAShapeLayer)?.strokeEnd = viewModel.timeProgress
    }
    
    func updateList() {
        // TODO: 추후 MainViewStatus와 GroupStatus를 통합할 때 개선 필요
        emptyListView.isHidden = !(viewModel.currentGroup.status == .running && viewModel.todoList.isEmpty)
        todoListView.isHidden = !(viewModel.currentGroup.status == .running && viewModel.todoList.count > 0)
        
        allButton.setIsColorful(viewModel.currentFilter == .all)
        waitButton.setIsColorful(viewModel.currentFilter == .wait)
        rejectButton.setIsColorful(viewModel.currentFilter == .reject)
        approveButton.setIsColorful(viewModel.currentFilter == .approve)
        
        filterStackView.isHidden = todoListView.isHidden
        
        todoListStackView.isHidden = viewModel.todoList.isEmpty
        todoListStackView.subviews.forEach { todoListStackView.removeArrangedSubview($0) }
        viewModel.todoList
            .map {
                let todoListItemButton = TodoListItemButton(todo: $0)
                todoListItemButton.addAction(
                    UIAction { [weak self, weak todoListItemButton] _ in
                        guard let self, let button = todoListItemButton else { return }
                        let isWaitCertification = TodoStatus(rawValue: button.todo.status) == .waitCertification
                        let popupType: PopupTypes = isWaitCertification ? .certification : .certificationInfo
                        coordinator?.showPopup(self, type: popupType, todoInfo: button.todo)
                    }, for: .touchUpInside
                )
                return todoListItemButton
            }
            .forEach { todoListStackView.addArrangedSubview($0) }
        
        // TODO: todoListView가 hidden인데 todoList가 비어있을 때 보여줘야 하는데 해당 조건이 가능한지 확인 필요
        emptyDescriptionView.isHidden = !(!todoListView.isHidden && viewModel.todoList.isEmpty)
        emptyDescriptionView.setType(viewModel.currentFilter)
    }
    
    @objc private func tappedGroupNameStackView() {
        // FIXME: 추후 공용 컴포넌트 group sheet 추가되면 수정
        print("show group sheet")
//        viewModel.setChallengeIndex(index: viewModel.currentChallengeIndex + 1)
//        updateView()
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if viewModel.isBlockPanGesture { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            let newOffset = viewModel.getNewOffset(
                from: dogetherSheetTopConstraint?.layoutConstraints.first?.constant ?? 0,
                with: translation.y
            )
            dogetherSheetTopConstraint?.update(offset: newOffset)
            updateAlpha(alpha: 1 - (SheetStatus.normal.offset - newOffset) / (SheetStatus.normal.offset - SheetStatus.expand.offset))
            view.layoutIfNeeded()
            
        case .ended:
            updateSheet(viewModel.updateSheetStatus(with: translation.y))
            
        default:
            break
        }
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && todoScrollView.contentOffset.y > 0 { return false }
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
