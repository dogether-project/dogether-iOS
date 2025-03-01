//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import Foundation
import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let viewModel = SplashViewModel()
    
    private let logoView: UIView = {
        let view = UIView()
        
        let logoImage = UIImageView(image: .logo)
        
        let typoImage = UIImageView(image: .logoTypo)
        
        [logoImage, typoImage].forEach { view.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(82)
        }
        
        typoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(127)
            $0.height.equalTo(30)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadApp()
    }
    
    override func configureView() { }
    
    override func configureHierarchy() {
        [logoView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        logoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(127)
            $0.height.equalTo(136)
        }
    }
}
