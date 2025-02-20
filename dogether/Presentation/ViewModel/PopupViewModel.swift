//
//  PopupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import Foundation
import UIKit

final class PopupViewModel {
    private(set) var certificationMediaUrl: String?
    private(set) var rejectReason: String?
    
    func uploadImage(image: UIImage) {
        Task { @MainActor in
            self.certificationMediaUrl = try await S3Manager.shared.uploadImage(image: image)
        }
    }
    
    func certifyTodo(todoId: Int, certificationContent: String?) async throws {
        guard let content = certificationContent, let mediaUrl = certificationMediaUrl else { return }
        let request = CertifyTodoRequest(content: content, mediaUrls: [mediaUrl])
        try await NetworkManager.shared.request(TodosRouter.certifyTodo(todoId: String(todoId), certifyTodoRequest: request))
    }
}
