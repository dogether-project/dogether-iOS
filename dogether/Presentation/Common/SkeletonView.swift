//
//  SkeletonView.swift
//  dogether
//
//  Created by seungyooooong on 11/13/25.
//

import Foundation

final class SkeletonView: BaseView {
    override func configureView() {
        backgroundColor = Color.Background.surface
        layer.cornerRadius = 8
    }
}
