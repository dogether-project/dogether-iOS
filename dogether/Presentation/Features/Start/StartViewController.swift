//
//  StartViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

import RxSwift
import RxCocoa

final class StartViewController: BaseViewController {
    private let startPage = StartPage()
    private let viewModel = StartViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        pages = [startPage]
        
        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        guard let datas = datas as? StartViewDatas else { return }
        viewModel.isFirstGroup.accept(datas.isFirstGroup)
    }
    
    override func bindViewModel() {
        viewModel.isFirstGroup
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] isFirst in
                guard let self else { return }
                startPage.viewDidUpdate(isFirst)
            })
            .disposed(by: disposeBag)
    }
}
