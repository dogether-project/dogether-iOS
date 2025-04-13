//
//  LoadingManager.swift
//  dogether
//
//  Created by yujaehong on 4/9/25.
//

import Foundation
import Combine

final class LoadingManager {
    static let shared = LoadingManager()
    private init() {}

    let loadingPublisher = PassthroughSubject<Bool, Never>()

    func show() {
        loadingPublisher.send(true)
    }

    func hide() {
        loadingPublisher.send(false)
    }
}
