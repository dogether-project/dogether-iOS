//
//  CertificateViewModel.swift
//  dogether
//
//  Created by seungyooooong on 7/13/25.
//

import UIKit

import RxRelay

final class CertificateViewModel {
    private let challengeGroupUseCase: ChallengeGroupUseCase
    
    private(set) var certificateViewDatas = BehaviorRelay<CertificateViewDatas>(value: CertificateViewDatas())
    private(set) var certificateButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )

    init() {
        let repository = DIManager.shared.getChallengeGroupsRepository()
        self.challengeGroupUseCase = ChallengeGroupUseCase(repository: repository)
    }
}

extension CertificateViewModel {
    func updateButtonStatus(status: ButtonStatus) {
        certificateButtonViewDatas.update { $0.status = status }
    }
}

extension CertificateViewModel {
    func certifyTodo() async throws {
        let todo = certificateViewDatas.value.todo
        guard let content = todo.certificationContent,
              let mediaUrl = todo.certificationMediaUrl else { return }
        try await challengeGroupUseCase.certifyTodo(todoId: todo.id, content: content, mediaUrl: mediaUrl)
    }
    
    func uploadImage(image: UIImage) async throws{
        Task {
            let mediaUrl = try await S3Manager.shared.uploadImage(image: image)
            
            certificateViewDatas.update {
                $0.todo.certificationMediaUrl = mediaUrl
            }
        }
    }
}
