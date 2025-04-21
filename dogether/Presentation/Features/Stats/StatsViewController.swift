//
//  StatsViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class StatsViewController: BaseViewController {
    
    private let dogetherHeader = NavigationHeader(title: "통계")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        
    }
    
    override func configureAction() {
        dogetherHeader.delegate = self
        
    }
    
    override func configureHierarchy() {
        [dogetherHeader].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
    }
}
