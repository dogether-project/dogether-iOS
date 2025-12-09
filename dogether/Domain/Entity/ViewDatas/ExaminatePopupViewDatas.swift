//
//  ExaminatePopupViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import Foundation

struct ExaminatePopupViewDatas: BaseEntity {
    var feedback: String
    var keyboardHeight: CGFloat
    var isShowKeyboard: Bool
    var isFirstResponder: Bool
    
    init(
        feedback: String = "",
        keyboardHeight: CGFloat = 0,
        isShowKeyboard: Bool = true,
        isFirstResponder: Bool = false
    ) {
        self.feedback = feedback
        self.keyboardHeight = keyboardHeight
        self.isShowKeyboard = isShowKeyboard
        self.isFirstResponder = isFirstResponder
    }
}
