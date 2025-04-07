//
//  TodoCertificationsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsRepositoryTest: TodoCertificationsProtocol {
    func getReviews() async throws -> GetReviewsResponse {
        let dailyTodoCertifications = [ReviewModel(id: 0, content: "content", mediaUrls: [""], todoContent: "todoContent", doer: "doer")]
        return GetReviewsResponse(dailyTodoCertifications: dailyTodoCertifications)
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws { }
}
