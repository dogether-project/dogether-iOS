//
//  LoadingViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/18/25.
//

import UIKit

final class LoadingViewController: BaseViewController {
    private let loadingPage = LoadingPage()
    private let viewModel = LoadingViewModel()
    
    override func viewDidLoad() {
        pages = [loadingPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func setViewDatas() {
        if let datas = datas as? LoadingViewDatas {
            viewModel.loadingViewDatas.accept(datas)
        }
        
        bind(viewModel.loadingViewDatas)
    }
}

extension LoadingViewController {
    private func onAppear() {
        // MARK: - setup for loading ui
        // FIXME: 추후 수정, LoadingViewModel & LoadingViewDatas & isShowLoading 적용
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        
        Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            view.isHidden = false
        }
    }
}
