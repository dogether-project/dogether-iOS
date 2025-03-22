//
//  StartViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class StartViewModel {
    private(set) var isShowFloating: Bool = true
    
    func hideFloating(completeAction: @escaping () -> Void) {
        isShowFloating = false
        completeAction()
    }
}
