//
//  StepThreeView.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

final class StepThreeView: BaseView {
    private let dogetherGroupInfo = DogetherGroupInfo()
    
    override func configureHierarchy() {
        [dogetherGroupInfo].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherGroupInfo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(267)
        }
    }
}
