//
//  PopupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import UIKit

import RxRelay

final class PopupViewModel {
    private(set) var alertPopupViewDatas = BehaviorRelay<AlertPopupViewDatas?>(value: nil)
    private(set) var examinatePopupViewDatas = BehaviorRelay<ExaminatePopupViewDatas?>(value: nil)
    private(set) var registerButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )
}

extension PopupViewModel {
    func updateIsFirstResponder(isFirstResponder: Bool) {
        examinatePopupViewDatas.update { $0?.isFirstResponder = isFirstResponder }
    }
    
    func updateKeyboardHeight(height: CGFloat) {
        examinatePopupViewDatas.update { $0?.keyboardHeight = height }
    }
    
    func updateFeedback(feedback: String) {
        examinatePopupViewDatas.update { $0?.feedback = feedback }
        registerButtonViewDatas.update { $0.status = feedback.count > 0 ? .enabled : .disabled }
    }
}
