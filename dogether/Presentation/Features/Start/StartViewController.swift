//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

final class StartViewController: BaseViewController {
    private let startPage = StartPage()
    private let viewModel = StartViewModel()

    override func viewDidLoad() {
        startPage.delegate = self
        
        pages = [startPage]
        
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? StartViewDatas else { return }
        viewModel.startViewDatas.accept(datas)
    }
    
    override func bindViewModel() {
        bind(viewModel.startViewDatas)
    }
}

// MARK: - delegate
protocol StartDelegate {
    func startAction(_ destination: BaseViewController)
}

extension StartViewController: StartDelegate {
    func startAction(_ destination: BaseViewController) {
        coordinator?.pushViewController(destination)
    }
}
