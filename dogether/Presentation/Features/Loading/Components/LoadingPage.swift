//
//  LoadingPage.swift
//  dogether
//
//  Created by seungyooooong on 12/29/25.
//

import UIKit

import Lottie

final class LoadingPage: BasePage {
    private let animationView = LottieAnimationView(name: "dogetherLoading")
    
    private var currentIsShowLoading: Bool?
    
    override func configureView() {
        animationView.play()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(animationView)
    }
    
    override func configureConstraints() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
}
