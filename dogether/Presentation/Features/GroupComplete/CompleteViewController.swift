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
    
    init(datas: CompleteViewDatas) {
        super.init(nibName: nil, bundle: nil)
        self.datas = datas
        viewModel.setDatas(datas)
        pages = [completePage]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        completePage.delegate = self
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        bind(viewModel.completeViewDatas)
    }
}

protocol CompleteDelegate: AnyObject {
    func goHomeAction()
    func shareJoinCodeAction()
}

extension CompleteViewController: CompleteDelegate {
    func goHomeAction() {
        coordinator?.setNavigationController(MainViewController())
    }

    func shareJoinCodeAction() {
        let invite = viewModel.shareGroupCode()
        present(UIActivityViewController(activityItems: invite, applicationActivities: nil), animated: true)
    }
}
