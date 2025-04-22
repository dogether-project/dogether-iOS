//
//  MyTodosListViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class MyTodoListViewController: BaseViewController {
    
    private let navigationHeader = NavigationHeader(title: "인증 목록")
    
    private let emptyStateView = EmptyStateView(
        title: "아직 작성된 투두가 없어요",
        description: "오늘 하루 이루고 싶은 목표를 입력해보세요!"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
    }
    
    override func configureHierarchy() {
        [navigationHeader, emptyStateView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(160)
            $0.centerX.equalToSuperview()
        }
    }
}
