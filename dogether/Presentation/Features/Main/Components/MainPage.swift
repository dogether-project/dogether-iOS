//
//  MainPage.swift
//  dogether
//
//  Created by seungyooooong on 8/26/25.
//

import UIKit
import SnapKit

final class MainPage: BasePage {
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    
    private let dosikImageView = UIImageView(image: .noteDosik)
    
    private let dosikCommentButton = DosikCommentButton()
    
    private let groupInfoView = GroupInfoView()
    
    private var bottomSheetViewController: BottomSheetViewController?
    
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
    
    private let timerView = TimerView()
    private let todoListView = TodoListView()
    private let todayEmptyView = TodayEmptyView()
    private let pastEmptyView = PastEmptyView()
    private let doneView = DoneView()
    
    private(set) var sheetStatus: SheetStatus = .normal
    
    override func configureView() {
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach { $0.isHidden = true }
    }
    
    override func configureAction() {
        dogetherHeader.delegate = coordinatorDelegate
        
//        let groupNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGroupNameStackView))
//        groupInfoView.groupNameStackView.addGestureRecognizer(groupNameTapGesture)
//        
//        let joinCodeTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedJoinCodeStackView))
//        groupInfoView.joinCodeStackView.addGestureRecognizer(joinCodeTapGesture)
//        
//        rankingButton.addAction(
//            UIAction { [weak self] _ in
//                guard let self else { return }
//                let rankingViewController = RankingViewController()
//                rankingViewController.viewModel.groupId = viewModel.currentGroup.id
//                coordinator?.pushViewController(rankingViewController)
//            }, for: .touchUpInside
//        )
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
//        [sheetHeaderView.prevButton, sheetHeaderView.nextButton].forEach { button in
//            button.addAction(
//                UIAction { [weak self] _ in
//                    guard let self else { return }
//                    let newOffset = viewModel.dateOffset + button.tag
//                    viewModel.setFilter(filter: .all)
//                    viewModel.setDateOffset(offset: newOffset)
//                    Task {
//                        try await self.viewModel.updateListInfo()
//                        await MainActor.run {
//                            self.updateView()
//                            self.updateList()
//                        }
//                    }
//                }, for: .touchUpInside
//            )
//        }
//        
//        todoListView.todoScrollView.delegate = self
//        
//        [todoListView.allButton, todoListView.waitButton, todoListView.rejectButton, todoListView.approveButton].forEach { button in
//            button.addAction(
//                UIAction { [weak self, weak button] _ in
//                    guard let self, let button else { return }
//                    self.viewModel.setFilter(filter: button.type)
//                    Task { @MainActor in
//                        self.updateList()
//                    }
//                }, for: .touchUpInside
//            )
//        }
//        
//        [todoListView.addTodoButton, todayEmptyView.todoButton].forEach { button in
//            button.addAction(
//                UIAction { [weak self] _ in
//                    guard let self else { return }
//                    let todoWriteViewController = TodoWriteViewController()
//                    todoWriteViewController.viewModel.groupId = viewModel.currentGroup.id
//                    todoWriteViewController.viewModel.todos = viewModel.todoList.map { WriteTodoInfo(content: $0.content, enabled: false) }
//                    coordinator?.pushViewController(todoWriteViewController)
//                }, for: .touchUpInside
//            )
//        }
    }
    
    override func configureHierarchy() {
        [dogetherHeader, dosikImageView, dosikCommentButton, groupInfoView, rankingButton, dogetherSheet].forEach { addSubview($0) }
        
        [sheetHeaderView, timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach { dogetherSheet.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dosikImageView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom)
            $0.right.equalToSuperview().inset(16)
            $0.width.height.equalTo(100)
        }
        
        dosikCommentButton.snp.makeConstraints {
            $0.bottom.equalTo(dosikImageView.snp.top).offset(-6)
            $0.right.equalTo(dosikImageView)
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
            dogetherSheetTopConstraint = $0.top.equalToSuperview().offset(SheetStatus.normal.offset).constraint
            $0.bottom.equalToSuperview().offset(UIApplication.safeAreaOffset.bottom)
            $0.left.right.equalToSuperview()
        }
        
        sheetHeaderView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheet).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        [timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(sheetHeaderView.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupViewDatas, datas.groups.count > 0 {
            groupInfoView.viewDidUpdate(datas.groups[0])
        }
    }
}

// MARK: - about pan gesture
extension MainPage: UIGestureRecognizerDelegate {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .changed:
            let newOffset = getNewOffset(
                from: dogetherSheetTopConstraint?.layoutConstraints.first?.constant ?? 0,
                with: translation.y
            )
            dogetherSheetTopConstraint?.update(offset: newOffset)
            updateAlpha(alpha: 1 - (SheetStatus.normal.offset - newOffset) / (SheetStatus.normal.offset - SheetStatus.expand.offset))
            layoutIfNeeded()

        case .ended:
            updateSheet(updateSheetStatus(with: translation.y))

        default:
            break
        }
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if sheetStatus == .expand && todoListView.todoScrollView.contentOffset.y > 0 { return false }
        return true
    }
}

// MARK: - about sheet
extension MainPage {
    private func updateSheet(_ status: SheetStatus) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            dogetherSheetTopConstraint?.update(offset: status.offset)
            updateAlpha(alpha: status == .normal ? 1 : 0)
            layoutIfNeeded()
        }
    }
    
    private func updateAlpha(alpha: CGFloat) {
        [dosikImageView, groupInfoView.groupInfoStackView, groupInfoView.durationStackView, rankingButton].forEach {
            $0.alpha = alpha
        }
    }
    
    private func getNewOffset(from currentOffset: CGFloat, with translation: CGFloat) -> CGFloat {
        switch sheetStatus {
        case .expand:
            if translation > 0 { return min(SheetStatus.normal.offset, SheetStatus.expand.offset + translation) }
            return currentOffset
        case .normal:
            if translation < 0 { return max(0, SheetStatus.normal.offset + translation) }
            return currentOffset
        }
    }
    
    private func updateSheetStatus(with translation: CGFloat) -> SheetStatus {
        switch sheetStatus {
        case .expand:
            sheetStatus = translation > 100 ? .normal : .expand
        case .normal:
            sheetStatus = translation < -100 ? .expand : .normal
        }
        return sheetStatus
    }
}
