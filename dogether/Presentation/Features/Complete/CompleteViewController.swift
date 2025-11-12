//
//  CompleteViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

final class CompleteViewController: BaseViewController {
    private let completePage = CompletePage()
    private let viewModel = CompleteViewModel()
    
    override func viewDidLoad() {
        pages = [completePage]
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
         if let datas = datas as? CompleteViewDatas {
             viewModel.completeViewDatas.accept(datas)
         }
         
         bind(viewModel.completeViewDatas)
     }
    
    override func bindAction() {
        completePage.homeTap
            .emit(onNext: { [weak self] in
                self?.coordinator?.setNavigationController(MainViewController())
            })
            .disposed(by: disposeBag)
        
        completePage.shareTap
            .emit(onNext: { [weak self] in
                guard let self else { return }
                let data = viewModel.completeViewDatas.value
                let invite = SystemManager.inviteGroup(
                    groupName: data.groupInfo.name,
                    joinCode: data.joinCode
                )
                present(UIActivityViewController(activityItems: invite, applicationActivities: nil), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
