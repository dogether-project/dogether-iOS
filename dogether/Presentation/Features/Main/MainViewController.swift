//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    private let mainPage = MainPage()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        mainPage.delegate = self
        
        pages = [mainPage]

        super.viewDidLoad()
        
        onAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMainView()
    }
    
    override func setViewDatas() { }
    
    override func bindViewModel() {
        viewModel.bottomSheetViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: BottomSheetViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                mainPage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
        
        viewModel.groupViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: GroupViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                mainPage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
        
        viewModel.sheetViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: SheetViewDatas())
            .drive(onNext: { [weak self] datas in
                guard let self else { return }
                mainPage.viewDidUpdate(datas)
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    // MARK: () -> Void 타입이어야 updateViewController지정 가능
    private func loadMainView() {
        loadMainView(selectedIndex: nil)
    }
    
    private func loadMainView(selectedIndex: Int?) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let groupViewDatas = try await viewModel.getGroups()
                viewModel.groupViewDatas.accept(groupViewDatas)
                
                if groupViewDatas.groups.isEmpty {
                    coordinator?.setNavigationController(StartViewController())
                    return
                }
                
                let currentGroup = groupViewDatas.groups[groupViewDatas.index]
                if currentGroup.status == .ready {
                    viewModel.sheetViewDatas.update { $0.status = .timer }
                    return
                }
                
                let dateOffset = viewModel.sheetViewDatas.value.dateOffset
                if currentGroup.status == .finished && dateOffset == 0 {
                    viewModel.sheetViewDatas.update { $0.status = .done }
                    return
                }
                
                let todoList = try await viewModel.getTodoList(dateOffset: dateOffset, groupId: currentGroup.id)
                viewModel.sheetViewDatas.update {
                    $0.todoList = todoList
                    $0.status = dateOffset == 0 && todoList.isEmpty ? .createTodo :
                    dateOffset == 0 && todoList.count > 0 ? .certificateTodo :
                    dateOffset < 0 && todoList.isEmpty ? .emptyList : .todoList
                }

            } catch let error as NetworkError {
                await MainActor.run {
                    ErrorHandlingManager.presentErrorView(
                        error: error,
                        presentingViewController: self,
                        coordinator: self.coordinator,
                        retryHandler: { [weak self] in
                            guard let self else { return }
                            loadMainView()
                        },
                        showCloseButton: false
                    )
                }
            }
        }
    }
}

// MARK: - update UI
extension MainViewController {
    private func checkAuthorization() {
        Task { [weak self] in
            guard let self else { return }
            let userNoti = UNUserNotificationCenter.current()
            let settings = await userNoti.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                try await userNoti.requestAuthorization(options: [.alert, .badge, .sound])
            case .denied:
                await MainActor.run {
                    self.coordinator?.showPopup(
                        self,
                        type: .alert,
                        alertType: .pushNotice,
                        completion:  { _ in
                            SystemManager().openSettingApp()
                        }
                    )
                }
            default:    // MARK: .authorized, .provisional, .ephemeral
                break
            }
        }
    }
    
//    private func updateView() {
//        timerView.isHidden = !(viewModel.currentGroup.status == .ready)
//        todoListView.isHidden = viewModel.todoList.isEmpty
//        todayEmptyView.isHidden = !(viewModel.todoList.isEmpty && viewModel.dateOffset == 0) || viewModel.currentGroup.status != .running
//        pastEmptyView.isHidden = !(viewModel.todoList.isEmpty && viewModel.dateOffset < 0)
//        doneView.isHidden = !(viewModel.currentGroup.status == .dDay && viewModel.dateOffset == 0)
//        
//        dosikCommentButton.updateUI(
//            comment: viewModel.currentGroup.status == .dDay ? "그룹이 종료됐어요!" :
//                viewModel.currentGroup.progress >= 1.0 ? "마지막 인증일이에요!\n내일부터 인증이 불가능해요." : nil
//        )
//    }
//    
//    private func updateTimer() {
//        timerView.updateTimer(time: viewModel.time, timeProgress: viewModel.timeProgress)
//    }
//    
//    func updateList() {
//        todoListView.updateList(todoList: viewModel.todoList, filter: viewModel.currentFilter, isToday: viewModel.dateOffset == 0)
//        
//        todoListView.todoListStackView.arrangedSubviews.forEach { todoListItemView in
//            guard let todoListItemButton = todoListItemView as? TodoListItemButton else { return }
//            todoListItemButton.addAction(
//                UIAction { [weak self, weak todoListItemButton] _ in
//                    guard let self, let button = todoListItemButton else { return }
//                    let isCertification = TodoStatus(rawValue: button.todo.status) == .waitCertification
//                    if isCertification {
//                        if button.isToday {
//                            let certificationViewController = CertificationViewController()
//                            certificationViewController.viewModel.todoInfo = button.todo
//                            coordinator?.pushViewController(certificationViewController)
//                        } else { return }
//                    } else {
//                        let certificationInfoViewController = CertificationInfoViewController()
//                        certificationInfoViewController.todoInfo = button.todo
//                        coordinator?.pushViewController(certificationInfoViewController)
//                    }
//                }, for: .touchUpInside
//            )
//        }
//    }
}

// MARK: - about scroll
extension MainViewController: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if viewModel.sheetStatus == .normal {
//            scrollView.panGestureRecognizer.isEnabled = false
//            scrollView.panGestureRecognizer.isEnabled = true
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if viewModel.sheetStatus == .normal {
//            scrollView.contentOffset.y = 0
//            return
//        }
//    }
}

// MARK: - about bottom sheet
//extension MainViewController: BottomSheetDelegate {
//    private func configureBottomSheetViewController() {
//        let bottomSheetItem = viewModel.challengeGroupInfos.map { $0.bottomSheetItem }
//        let selectedItem = viewModel.currentGroup.bottomSheetItem
//        
//        if bottomSheetItem.isEmpty { return }
//
//        bottomSheetViewController = BottomSheetViewController(titleText: "그룹 선택",
//                                                              bottomSheetItem: bottomSheetItem,
//                                                              shouldShowAddGroupButton: viewModel.challengeGroupInfos.count < 5,
//                                                              selectedItem: selectedItem)
//        
//        bottomSheetViewController?.coordinator = self.coordinator
//        bottomSheetViewController?.modalPresentationStyle = .overCurrentContext
//        bottomSheetViewController?.modalTransitionStyle = .coverVertical
//        
//        bottomSheetViewController?.didSelectOption = { [weak self] selectedItem in
//            guard let self,
//                  let selectedGroup = selectedItem.value as? ChallengeGroupInfo,
//                  let selectedIndex = viewModel.challengeGroupInfos.firstIndex(of: selectedGroup) else { return }
//            
//            viewModel.setChallengeIndex(index: selectedIndex)
//            viewModel.saveLastSelectedGroup()
//            viewModel.setDateOffset(offset: 0)
//            loadMainView(selectedIndex: selectedIndex)
//        }
//    }
//    
//    func presentBottomSheet() {
//        if presentedViewController == nil,
//           let bottomSheetViewController {
//            present(bottomSheetViewController, animated: true)
//        }
//    }
//}

// MARK: - delegate
protocol MainDelegate {
    func updateAlphaBySheet(alpha: CGFloat)
    func goRankingViewAction()
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectGroupAction(index: Int)
    func addGroupAction()
    func inviteAction()
    func goPastAction()
    func goFutureAction()
}

extension MainViewController: MainDelegate {
    private func onAppear() {
        checkAuthorization()
        coordinator?.updateViewController = loadMainView
        
        // ???: 화면 전환을 고려하면 일부러 강한 참조를 걸어야할까
        // TODO: 알림 권한을 거부한 사용자에 대한 로직은 추후에 추가
        Task { [weak self] in
            guard let self else { return }
            let reviews = try await viewModel.getReviews()
            if reviews.isEmpty { return }
            
            await MainActor.run {
                self.coordinator?.showModal(reviews: reviews)
            }
        }
    }
    
    func updateAlphaBySheet(alpha: CGFloat) {
        viewModel.sheetViewDatas.update { $0.alpha = alpha }
    }
    
    func goRankingViewAction() {
        let rankingViewController = RankingViewController()
        // FIXME: rankingView RxSwift 도입 시 수정
        rankingViewController.viewModel.groupId = viewModel.groupViewDatas.value.index
        coordinator?.pushViewController(rankingViewController)
    }
    
    func updateBottomSheetVisibleAction(isShowSheet: Bool) {
        viewModel.bottomSheetViewDatas.update { $0.isShowSheet = isShowSheet }
    }
    
    func selectGroupAction(index: Int) {
        viewModel.groupViewDatas.update { $0.index = index }
        viewModel.saveLastSelectedGroupIndex(index: index)
//        viewModel.sheetViewDatas.update { $0.status = viewModel.groupViewDatas.value.groups[index].status }
    }
    
    func addGroupAction() {
        let startViewController = StartViewController()
        let startViewDatas = StartViewDatas(isFirstGroup: false)
        coordinator?.pushViewController(startViewController, datas: startViewDatas)
    }
    
    func inviteAction() {
        let groupData = viewModel.groupViewDatas.value.groups[viewModel.groupViewDatas.value.index]
        let inviteGroup = SystemManager.inviteGroup(groupName: groupData.name, joinCode: groupData.joinCode)
        present(UIActivityViewController(activityItems: inviteGroup, applicationActivities: nil), animated: true)
    }
    
    func goPastAction() {
        // FIXME: 추후 수정
//        viewModel.sheetViewDatas.update { $0.date = "test" }
    }
    
    func goFutureAction() {
        // FIXME: 추후 수정
//        viewModel.sheetViewDatas.update { $0.date = "test" }
        
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
    }
}
