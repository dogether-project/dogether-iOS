//
//  GroupManagementViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class GroupManagementViewController: BaseViewController {
    private let page = GroupManagementPage()
    private let viewModel = GroupManagementViewModel()

    override func viewDidLoad() {
        page.delegate = self
        pages = [page]
        
        super.viewDidLoad()

        coordinator?.updateViewController = loadGroups
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGroups()
    }

    override func setViewDatas() {
        bind(viewModel.viewDatas)
    }
}

extension GroupManagementViewController {
    private func loadGroups() {
        Task { [weak self] in
            guard let self else { return }

            do {
                try await viewModel.loadGroups()
                await MainActor.run {
                    self.showMain()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.hideMain()
                    self.showError(error)
                }
            }
        }
    }
}

extension GroupManagementViewController {
    private func showError(_ error: NetworkError) {}
    private func showMain() {}
    private func hideMain() {}
}

// MARK: - delegate
protocol GroupManagementDelegate: AnyObject {
    func leaveGroupTapped(_ group: GroupEntity)
    func addGroupAction()
}

extension GroupManagementViewController: GroupManagementDelegate {
    func leaveGroupTapped(_ group: GroupEntity) {
        coordinator?.showPopup(self, type: .alert, alertType: .leaveGroup) { [weak self] _ in
            guard let self else { return }
            tryLeaveGroup(groupId: group.id)
        }
    }
    
    func addGroupAction() {
        coordinator?.pushViewController(GroupCreateViewController())
    }
}

extension GroupManagementViewController {
    private func tryLeaveGroup(groupId: Int) {
        Task {
            do {
                try await viewModel.leaveGroup(groupId: groupId)
                await MainActor.run {
                    loadGroups()
                }
            } catch let error as NetworkError {
                hideMain()
                showError(error)
            }
        }
    }
}
