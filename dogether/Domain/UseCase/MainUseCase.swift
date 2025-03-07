//
//  MainUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

final class MainUseCase {
    private let repository: MainInterface
    
    init(repository: MainInterface) {
        self.repository = repository
    }
}
