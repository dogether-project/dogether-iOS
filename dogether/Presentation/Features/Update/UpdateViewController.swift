//
//  UpdateViewController.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

import UIKit

final class UpdateViewController: BaseViewController {
    private let updatePage = UpdatePage()
    
    override func bindViewModel() { }
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [updatePage].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        updatePage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
