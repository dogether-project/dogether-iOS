//
//  ModalityViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import Foundation

import RxRelay

final class ModalityViewModel {
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var examinateViewDatas = BehaviorRelay<ExaminateViewDatas>(value: ExaminateViewDatas())
    private(set) var examinateButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )
    
    // MARK: - Computed
    var currentReview: ReviewEntity { examinateViewDatas.value.reviews[examinateViewDatas.value.index] }
    
    init() {
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
    
    func setReviews(reviews: [ReviewEntity]) {
        examinateViewDatas.update {
            $0.index = 0
            $0.reviews = reviews
        }
    }
    
    func reviewTodo() async throws {
        try await todoCertificationsUseCase.reviewTodo(
            todoId: String(currentReview.id),
            result: examinateViewDatas.value.result,
            reviewFeedback: examinateViewDatas.value.feedback
        )
    }
}
