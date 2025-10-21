//
//  CertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class CertificationViewController: BaseViewController {
    private let certificationPage = CertificationPage()
    private let viewModel = CertificationViewModel()
    
    override func viewDidLoad() {
        certificationPage.delegate = self
        
        pages = [certificationPage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificationViewDatas {
            viewModel.certificationViewDatas.accept(datas)
        }
        
        bind(viewModel.certificationViewDatas)
    }
}

// MARK: - delegate
protocol CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
}

extension CertificationViewController: CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: stackView)

        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if view.frame.contains(location) {
                viewModel.certificationViewDatas.update { $0.index = index }
                return
            }
        }
    }
}
