//
//  TestViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import UIKit

// TODO: 테스트 이후 삭제
class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let testButton = UIButton(type: .system)
        testButton.setTitle("API Test Button", for: .normal)
        
        testButton.addAction(UIAction(handler: { [weak self] _ in
            Task {
                try? await self?.performNetworkRequest()
            }
        }), for: .touchUpInside)
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @MainActor
    func performNetworkRequest() async throws {
        let response: CreateGroupResponse = try await NetworkManager.shared.request(.createGroup(createGroupRequest: CreateGroupRequest()))
        print(response)
    }
}
