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
        
        viewModel.timerViewDatas
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: TimerViewDatas())
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
                
                try await viewModel.setSheetViewDatasForCurrentGroup(
                    currentGroup: groupViewDatas.groups[groupViewDatas.index]
                )

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
}

// MARK: - delegate
protocol MainDelegate {
    func updateAlphaBySheet(alpha: CGFloat)
    func updateSheetStatus(sheetStatus: SheetStatus)
    func updateYOffsetOfSheet(yOffset: CGFloat)
    func updateIsScrollOnTop(isScrollOnTop: Bool)
    func goRankingViewAction()
    func updateBottomSheetVisibleAction(isShowSheet: Bool)
    func selectGroupAction(index: Int)
    func addGroupAction()
    func inviteAction()
    func goPastAction()
    func goFutureAction()
    func startTimerAction()
    func stopTimerAction()
    func goWriteTodoViewAction(todos: [TodoEntity])
    func selectFilterAction(filterType: FilterTypes)
    func goCertificationViewAction(todo: TodoEntity)
    func goCertificationInfoViewAction(todo: TodoEntity)
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
    
    func updateSheetStatus(sheetStatus: SheetStatus) {
        viewModel.sheetViewDatas.update { $0.sheetStatus = sheetStatus }
    }
    
    func updateYOffsetOfSheet(yOffset: CGFloat) {
        viewModel.sheetViewDatas.update { $0.yOffset = yOffset }
    }
    
    func updateIsScrollOnTop(isScrollOnTop: Bool) {
        viewModel.sheetViewDatas.update { $0.isScrollOnTop = isScrollOnTop }
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
        
        viewModel.sheetViewDatas.update { $0.dateOffset = 0 }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup(
                currentGroup: viewModel.groupViewDatas.value.groups[index]
            )
        }
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
        viewModel.sheetViewDatas.update {
            $0.dateOffset -= 1
            $0.filter = .all
        }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup(
                currentGroup: viewModel.groupViewDatas.value.groups[viewModel.groupViewDatas.value.index]
            )
        }
    }
    
    func goFutureAction() {
        viewModel.sheetViewDatas.update {
            $0.dateOffset += 1
            $0.filter = .all
        }
        
        Task {
            try await viewModel.setSheetViewDatasForCurrentGroup(
                currentGroup: viewModel.groupViewDatas.value.groups[viewModel.groupViewDatas.value.index]
            )
        }
    }
    
    func startTimerAction() {
        viewModel.startTimer()
    }
    
    func stopTimerAction() {
        viewModel.stopTimer()
    }
    
    func goWriteTodoViewAction(todos: [TodoEntity]) {
        // FIXME: TodoWriteView RxSwift 도입 시 수정
        let todoWriteViewController = TodoWriteViewController()
        let groupId = viewModel.groupViewDatas.value.groups[viewModel.groupViewDatas.value.index].id
        todoWriteViewController.viewModel.groupId = groupId
        todoWriteViewController.viewModel.todos = todos.map { WriteTodoInfo(content: $0.content, enabled: false) }
        coordinator?.pushViewController(todoWriteViewController)
    }
    
    func selectFilterAction(filterType: FilterTypes) {
        let filter = filterType == viewModel.sheetViewDatas.value.filter ? .all : filterType
        viewModel.sheetViewDatas.update { $0.filter = filter }
    }
    
    func goCertificationViewAction(todo: TodoEntity) {
        let certificationViewController = CertificationViewController()
        certificationViewController.viewModel.todoInfo = todo
        coordinator?.pushViewController(certificationViewController)
    }
    
    func goCertificationInfoViewAction(todo: TodoEntity) {
        let certificationInfoViewController = CertificationInfoViewController()
        certificationInfoViewController.todoInfo = todo
        coordinator?.pushViewController(certificationInfoViewController)
    }
}
