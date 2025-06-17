//
//  ErrorPresenter.swift
//  dogether
//
//  Created by yujaehong on 6/15/25.
//

import UIKit

final class ErrorPresenter {
    static func show(_ error: Error) {
        let message: String
        
        if let networkError = error as? NetworkError {
            message = networkError.description
        } else {
            message = error.localizedDescription
        }
        
        DispatchQueue.main.async {
            print("에러: \(message)")
            let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }
}
