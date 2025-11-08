//
//  MyPageViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/31/25.
//

import UIKit

final class MyPageViewController: BaseViewController {
    private let viewModel = MyPageViewModel()
    private let myPage = MyPagePage()
    
    override func viewDidLoad() {
        myPage.delegate = self
        pages = [myPage]
        super.viewDidLoad()
        
        coordinator?.updateViewController = loadProfileView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileView()
    }
    
    override func setViewDatas() {
        bind(viewModel.profileViewDatas)
    }
}

extension MyPageViewController {
    private func loadProfileView() {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await viewModel.loadProfileView()
            } catch let error as NetworkError {
                await MainActor.run {
                    ErrorHandlingManager.presentErrorView(
                        error: error,
                        presentingViewController: self,
                        coordinator: coordinator,
                        retryHandler: { [weak self] in
                            self?.loadProfileView()
                        }
                    )
                }
            }
        }
    }
}

protocol MyPageDelegate: AnyObject {
    func goStatsViewAction()
    func goMyTodoListAction()
    func goGroupManagementAction()
    func goSettingViewAction()
}

extension MyPageViewController: MyPageDelegate {
    func goStatsViewAction() {
        coordinator?.pushViewController(StatsViewController())
    }
    func goMyTodoListAction() {
        coordinator?.pushViewController(CertificationListViewController())
    }
    func goGroupManagementAction() {
        coordinator?.pushViewController(GroupManagementViewController())
    }
    func goSettingViewAction() {
        coordinator?.pushViewController(SettingViewController())
    }
}
