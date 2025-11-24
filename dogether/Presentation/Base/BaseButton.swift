//
//  BaseButton.swift
//  dogether
//
//  Created by seungyooooong on 4/9/25.
//

import UIKit
import RxSwift
import RxCocoa

class BaseButton: UIButton {
    /// 외부 노출용 Signal
    var tap: Signal<Void> { tapRelay.asSignal() }
    
    /// 내부 이벤트 스트림
//    fileprivate let tapRelay = PublishRelay<Void>()
    let tapRelay = PublishRelay<Void>()
    fileprivate let disposeBag = DisposeBag()
    
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
    func configureAction() {
        bindTap()
    }
    
    /// 뷰 계층을 구성하는 역할을 합니다
    func configureHierarchy() { }
    
    /// SnapKit을 이용해 레이아웃을 설정하는 역할을 합니다
    func configureConstraints() { }
    
    /// 뷰의 가변 요소들을 업데이트하는 역할을 합니다
    func updateView(_ data: any BaseEntity) { }
   
    /// 공통 버튼 탭 이벤트 바인딩
    private func bindTap() {
        rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: tapRelay)
            .disposed(by: disposeBag)
    }
}
