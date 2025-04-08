////
////  LottieAnimationLoadingView.swift
////  dogether
////
////  Created by yujaehong on 4/8/25.
////
//
//import UIKit
//import Lottie
//
//final class LottieAnimationLoadingView: UIView {
//
//    private let animationView = LottieAnimationView(name: "loadingCharacter") // 실제 JSON 이름으로 교체
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    private func setup() {
//        backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        isUserInteractionEnabled = true
//
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
//
//        addSubview(animationView)
//
//        NSLayoutConstraint.activate([
//            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            animationView.widthAnchor.constraint(equalToConstant: 80),
//            animationView.heightAnchor.constraint(equalToConstant: 80)
//        ])
//
//        print("LottieAnimationLoadingView: 로티 애니메이션 재생 시작!")
//    }
//
//    deinit {
//        print("LottieAnimationLoadingView: deinit 호출됨")
//    }
//
//    func dismiss() {
//        animationView.stop()
//        removeFromSuperview()
//        print("LottieAnimationLoadingView: 애니메이션 수동 종료 및 제거")
//    }
//}
