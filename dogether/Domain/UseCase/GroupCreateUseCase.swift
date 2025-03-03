//
//  GroupCreateUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupCreateUseCase {
    private let repository: GroupCreateInterface
    
    init(repository: GroupCreateInterface) {
        self.repository = repository
    }
}
