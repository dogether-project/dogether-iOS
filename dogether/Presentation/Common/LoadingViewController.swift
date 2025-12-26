//
//  LoadingViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/18/25.
//

import UIKit

import Lottie

final class LoadingViewController: BaseViewController {
    private let animationView = LottieAnimationView(name: "dogetherLoading")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configureView
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // configureHierarchy
        view.addSubview(animationView)
        
        // configureConstraints
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        
        // onAppear
        Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            view.isHidden = false
            animationView.play()
        }
    }
}
