//
//  PopupViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import UIKit

final class PopupViewModel {
    private let popupUseCase: PopupUseCase
    
    private(set) var stringContent: String?
    
    var popupType: PopupTypes?
    var alertType: AlertTypes?
    var todoInfo: TodoInfo?
    
    init() {
        let popupRepository = DIManager.shared.getPopupRepository()
        self.popupUseCase = PopupUseCase(repository: popupRepository)
    }
}

extension PopupViewModel {
    func setStringContent(_ text: String) {
        stringContent = text
    }
    
    func uploadImage(image: UIImage) {
        Task {
            todoInfo?.certificationMediaUrl = try await S3Manager.shared.uploadImage(image: image)
        }
    }
    
    func certifyTodo() async throws {
        guard let content = stringContent, let todoInfo, let mediaUrl = todoInfo.certificationMediaUrl else { return }
        let certifyTodoRequest = CertifyTodoRequest(content: content, mediaUrls: [mediaUrl])
        try await popupUseCase.certifyTodo(todoId: String(todoInfo.id), certifyTodoRequest: certifyTodoRequest)
    }
}
