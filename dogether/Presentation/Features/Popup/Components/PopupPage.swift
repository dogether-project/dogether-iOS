//
//  PopupPage.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import Foundation

final class PopupPage: BasePage {
    var delegate: AlertPopupDelegate? {
        didSet {
            alertStackView.delegate = delegate
        }
    }
    
    private let alertStackView = AlertStackView()
    
    override func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [alertStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        alertStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? AlertPopupViewDatas {
            alertStackView.updateView(datas)
        }
    }
}
