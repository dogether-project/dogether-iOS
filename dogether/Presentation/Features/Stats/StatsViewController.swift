//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class StatsViewController: BaseViewController {
    
    private let navigationHeader = NavigationHeader(title: "통계")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
    }
    
    override func configureHierarchy() {
        [navigationHeader].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
