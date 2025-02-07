//
//  TestViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import UIKit
import FirebaseMessaging

// TODO: 테스트 이후 삭제
class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let testButton = UIButton(type: .system)
        testButton.setTitle("TCM Token check button", for: .normal)

        testButton.addAction(UIAction(handler: { _ in
            checkFCMToken()
        }), for: .touchUpInside)
        
        testButton.setImage(Icons.profile, for: .normal)
        
        testButton.tintColor = Colors.red
        testButton.setTitleColor(Colors.red, for: .normal)
        
        testButton.titleLabel?.font = Fonts.extraBold(size: 20)

        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// TODO: 추후에 로그인 뷰에서 세부 구현
func checkFCMToken() {
    Messaging.messaging().token { token, _ in
        if let token = token { print("checked FCM Token: \(token)") }
    }
}
