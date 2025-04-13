//
//  BaseViewController.swift
//  dogether
//
//  Created by 박지은 on 2/9/25.
//

import UIKit
import Combine

class BaseViewController: UIViewController, CoordinatorDelegate {
    weak var coordinator: NavigationCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grey900
        
        configureView()
        configureAction()
        configureHierarchy()
        configureConstraints()
    }
    
    /// 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureView() { }
    
    /// 뷰의 동작 및 이벤트 처리를 설정하는 역할을 합니다
    func configureAction() { }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
    
    /// 로딩 상태를 받아와 coordinator를 통해 로딩 뷰의 표시 여부를 처리하는 역할을 합니다
    /// - Parameter publisher: 로딩 상태를 방출하는 Bool 타입의 Publisher
    func bindLoadingState<P: Publisher>(_ publisher: P) where P.Output == Bool, P.Failure == Never {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.coordinator?.showLoadingView()
                } else {
                    self?.coordinator?.hideLoadingView()
                }
            }
            .store(in: &cancellables)
    }
}
