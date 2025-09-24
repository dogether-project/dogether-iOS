//
//  MainPage.swift
//  dogether
//
//  Created by seungyooooong on 8/26/25.
//

import UIKit
import SnapKit

final class MainPage: BasePage {
    var delegate: MainDelegate?
    
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    
    private let dosikCommentButton = DosikCommentButton()
    private let groupInfoView = GroupInfoView()
    
    private let bottomSheetView = BottomSheetView()
    
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: .chart)
        imageView.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = "그룹 활동 한눈에 보기 !"
        label.textColor = .grey200
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        chevronImageView.tintColor = .grey200
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
            $0.width.height.equalTo(24)
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
        
        bottomSheetView.delegate = delegate
        groupInfoView.delegate = delegate
        sheetHeaderView.delegate = delegate
        
        rankingButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.goRankingViewAction()
            }, for: .touchUpInside
        )
        
        todayEmptyView.delegate = delegate
        todoListView.delegate = delegate
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
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
        [dogetherHeader, groupInfoView, dosikCommentButton,
         rankingButton, dogetherSheet, bottomSheetView].forEach { addSubview($0) }
        
        [sheetHeaderView, timerView, todoListView, todayEmptyView, pastEmptyView, doneView].forEach { dogetherSheet.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(143)
        }
        
        dosikCommentButton.snp.makeConstraints {
            $0.bottom.equalTo(groupInfoView.snp.top).offset(-6)
            $0.right.equalTo(groupInfoView)
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
                $0.bottom.equalToSuperview().inset(UIApplication.safeAreaOffset.bottom)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? BottomSheetViewDatas {
            bottomSheetView.viewDidUpdate(datas)
        }
        
        if let datas = data as? GroupViewDatas, datas.groups.count > 0 {
            bottomSheetView.viewDidUpdate(datas)
            groupInfoView.viewDidUpdate(datas.groups[datas.index])
            dosikCommentButton.viewDidUpdate(datas.groups[datas.index])
        }
        
        if let datas = data as? SheetViewDatas {
            groupInfoView.viewDidUpdate(datas)
            // FIXME: 추후 rankingButton View로 분리
//            rankingButton.viewDidUpdate(datas)
            rankingButton.alpha = datas.alpha
            sheetHeaderView.viewDidUpdate(datas)
            
            timerView.isHidden = !(datas.status == .timer)
            todoListView.isHidden = !(datas.status == .certificateTodo || datas.status == .todoList)
            todayEmptyView.isHidden = !(datas.status == .createTodo)
            pastEmptyView.isHidden = !(datas.status == .emptyList)
            doneView.isHidden = !(datas.status == .done)
            
            if datas.status == .timer {
                delegate?.startTimerAction()
            } else {
                delegate?.stopTimerAction()
            }
            
            if datas.status == .certificateTodo || datas.status == .todoList {
                todoListView.viewDidUpdate(datas)
            }
        }
        
        if let datas = data as? TimerViewDatas {
            timerView.viewDidUpdate(datas)
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
            delegate?.updateAlphaBySheet(
                alpha: 1 - (SheetStatus.normal.offset - newOffset) / (SheetStatus.normal.offset - SheetStatus.expand.offset)
            )
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
        // FIXME: offset 을 sheetViewDatas 에 두는 것이 꺼려짐, 우선 없이 테스트해보고 필요한 경우 isScrollOnTop 도 고려해보기
//        if sheetStatus == .expand && todoListView.todoScrollView.contentOffset.y > 0 { return false }
        return true
    }
}

// MARK: - about sheet
extension MainPage {
    private func updateSheet(_ status: SheetStatus) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            dogetherSheetTopConstraint?.update(offset: status.offset)
            delegate?.updateAlphaBySheet(alpha: status == .normal ? 1 : 0)
            layoutIfNeeded()
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
