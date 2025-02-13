//
//  BaseViewController.swift
//  dogether
//
//  Created by 박지은 on 2/9/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    init(type: GroupTypes = .create) {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureHierarchy()
        configureConstraints()
        
        view.backgroundColor = .grey900
    }
    
    func configureView() { } // 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureHierarchy() { } // 뷰 계층을 구성하는 역할을 합니다
    func configureConstraints() { } // SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
}
