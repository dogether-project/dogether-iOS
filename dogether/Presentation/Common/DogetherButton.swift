//
//  DogetherButton.swift
//  dogether
//
//  Created by seungyooooong on 2/9/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DogetherButton: BaseButton {
    private let title: String
    // ✅ 버튼 탭 이벤트 노출 (RxRelay)
    let tapRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    init(_ title: String) {
        self.title = title
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private(set) var currentViewDatas: DogetherButtonViewDatas?
    
    override func configureView() {
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.body1B
        layer.cornerRadius = 8
        
        rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // 중복클릭 방지
            .bind(to: tapRelay)
            .disposed(by: disposeBag)
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() { }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        guard let datas = data as? DogetherButtonViewDatas else { return }
        
        if currentViewDatas != datas {
            currentViewDatas = datas
            
            setTitleColor(datas.status.textColor, for: .normal)
            backgroundColor = datas.status.backgroundColor
            isEnabled = datas.status == .enabled
            
            isHidden = datas.isHidden
        }
    }
}

// MARK: - ViewDatas
struct DogetherButtonViewDatas: BaseEntity {
    var status: ButtonStatus
    var isHidden: Bool
    
    init(status: ButtonStatus = .enabled, isHidden: Bool = false) {
        self.status = status
        self.isHidden = isHidden
    }
}
