//
//  GroupCreateViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit
import SnapKit

final class GroupCreateViewController: BaseViewController {
    private let groupCreatePage = GroupCreatePage()
    private let viewModel = GroupCreateViewModel()
    
    override func viewDidLoad() {
        groupCreatePage.delegate = self
        
        pages = [groupCreatePage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        bind(viewModel.groupCreateViewDatas)
    }
}

extension GroupCreateViewController {
    private func tryCreateGroup() {
        Task {
            do {
                try await viewModel.createGroup()
                guard let joinCode = viewModel.joinCode else { return }
                await MainActor.run {
                    coordinator?.setNavigationController(
                        CompleteViewController(),
                        datas: CompleteViewDatas(
                            groupType: .create,
                            joinCode: joinCode,
                            groupInfo: ChallengeGroupInfo(name: viewModel.currentGroupName)
                        )
                    )
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        tryCreateGroup()
                    }
                )
            }
        }
    }
}

// MARK: - delegate
protocol GroupCreateDelegate {
    func changeCountAction(currentCount: Int)
}

extension GroupCreateViewController: GroupCreateDelegate {
    func changeCountAction(currentCount: Int) {
        viewModel.updateMemberCount(count: currentCount)
    }
}
