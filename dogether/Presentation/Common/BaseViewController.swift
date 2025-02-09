//
//  BaseViewController.swift
//  dogether
//
//  Created by 박지은 on 2/9/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        
        view.backgroundColor = .white
    }
    
    func configureHierarchy() { } // 뷰 계층을 구성하는 역할을 합니다
    func configureConstraints() { } // SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureView() { } // 뷰를 설정하는 역할을 합니다
}
