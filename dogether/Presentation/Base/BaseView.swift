//
//  BaseView.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureAction()
        configureHierarchy()
        configureConstraints()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    /// 뷰의 시각적인 속성을 설정하는 역할을 합니다
    func configureView() { }
    
    /// 뷰의 동작 및 이벤트 처리를 설정하는 역할을 합니다
    func configureAction() { }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
    
    /// 뷰의 가변 요소들을 업데이트하는 역할을 합니다
    func viewDidUpdate(_ data: any BaseEntity) {
        updateView(data)
        updateAction(data)
        updateHierarchy(data)
        updateConstraints(data)
    }
    
    /// 뷰의 시각적인 속성을 업데이트하는 역할을 합니다
    func updateView(_ data: any BaseEntity) { }
    
    /// 뷰의 동작 및 이벤트 처리를 업데이트하는 역할을 합니다
    func updateAction(_ data: any BaseEntity) { }
    
    /// 뷰 계층을 업데이트하는 역할을 합니다
    func updateHierarchy(_ data: any BaseEntity) { }
    
    /// SnapKit을 이용해 레이아웃을 업데이트하는 역할을 합니다
    func updateConstraints(_ data: any BaseEntity) { }
}
