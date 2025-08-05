//
//  LoadingViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/18/25.
//

import UIKit

import Lottie

final class LoadingViewController: BaseViewController {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "dogetherLoading") // 두식이 로딩 애니메이션.json
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        animationView.play()
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        view.addSubview(animationView)
    }
    
    override func configureConstraints() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
