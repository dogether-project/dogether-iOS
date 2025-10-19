//
//  CertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

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
    
}

extension CertificationViewController: CertificationDelegate {
    
}
