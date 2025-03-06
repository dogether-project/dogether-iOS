//
//  StartViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class StartViewModel {
    private(set) var isShowFloating: Bool = true
    
    func hideFloating() {
        isShowFloating = false
    }
    
    func navigate(destinationTag: Int) {
        guard let groupType = GroupTypes(rawValue: destinationTag) else { return }
        NavigationManager.shared.pushViewController(groupType.destination)
    }
}
