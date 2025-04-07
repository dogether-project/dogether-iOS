//
//  TodoRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class TodoRepositoryTest: TodoProtocol {
    func createTodos(createTodosRequest: CreateTodosRequest) async throws { }
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        let certify_pendings = (1 ... 2).map { TodoInfo(id: $0, content: "testTodo \($0)", status: "CERTIFY_PENDING") }
        let review_pendings = (3 ... 4).map {
            TodoInfo(id: $0, content: "testTodo \($0)", status: "REVIEW_PENDING", certificationContent: "test todo content \($0)")
        }
        let approves = (5 ... 6).map {
            TodoInfo(id: $0, content: "testTodo \($0)", status: "APPROVE", certificationContent: "test todo content \($0)")
        }
        let rejects = (7 ... 8).map {
            TodoInfo(
                id: $0, content: "testTodo \($0)testTodo \($0)testTodo \($0)", status: "REJECT",
                certificationContent: "test todo content \($0)test todo content \($0)test todo content \($0)", rejectReason: "test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)"
            )
        }
        let todos = certify_pendings + review_pendings + approves + rejects
        return GetMyTodosResponse(todos: todos)
    }
}
