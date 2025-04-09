//
//  LoadingEventBus.swift
//  dogether
//
//  Created by yujaehong on 4/9/25.
//

import Foundation
import Combine

final class LoadingEventBus {
    static let shared = LoadingEventBus()
    private init() {}

    let loadingPublisher = PassthroughSubject<Bool, Never>()

    func show() {
        loadingPublisher.send(true)
    }

    func hide() {
        loadingPublisher.send(false)
    }
}
