//
//  LoadingManager.swift
//  dogether
//
//  Created by seungyooooong on 5/19/25.
//

import UIKit

final class LoadingManager {
    static let shared = LoadingManager()
    
    private(set) var loadingWindow: UIWindow? = nil
    private(set) var loadingCount: Int = 0
    
    private init() { }
    
    func showLoading(minimumDelay: TimeInterval = 0.3) {
        loadingCount += 1
        
        if loadingWindow != nil { return }
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            try? await Task.sleep(nanoseconds: UInt64(minimumDelay * 1_000_000_000))
            
            guard loadingCount > 0, loadingWindow == nil,
                  let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            let window = UIWindow(windowScene: windowScene)
            window.frame = UIScreen.main.bounds
            window.rootViewController = LoadingViewController()
            window.windowLevel = .alert + 99
            window.makeKeyAndVisible()
            loadingWindow = window
        }
    }
    
    func hideLoading() {
        loadingCount -= 1
        
        if loadingCount <= 0 {
            Task { @MainActor [weak self] in
                guard let self else { return }
                loadingWindow?.isHidden = true
                loadingWindow = nil
            }
        }
    }
}
