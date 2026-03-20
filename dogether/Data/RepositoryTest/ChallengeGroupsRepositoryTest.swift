//
//  ChallengeGroupsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepositoryTest: ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws { }
    
    func getMyTodos(groupId: String, date: String) async throws -> [TodoEntity] {
        let certify_pendings = (1 ... 2).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .uncertified)
        }
        let review_pendings = (3 ... 4).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .reviewed(.pending), certificationContent: "test todo content \($0)")
        }
        let approves = (5 ... 6).map {
            TodoEntity(id: $0, content: "testTodo \($0)", status: .reviewed(.approve), certificationContent: "test todo content \($0)")
        }
        let rejects = (7 ... 8).map {
            TodoEntity(
                id: $0, content: "testTodo \($0)testTodo \($0)testTodo \($0)", status: .reviewed(.reject),
                certificationContent: "test todo content \($0)test todo content \($0)test todo content \($0)", reviewFeedback: "test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)test todo reject reason \($0)"
            )
        }
        return certify_pendings + review_pendings + approves + rejects
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, todos: [TodoEntity]) {
        return (index: 3, todos: [
            TodoEntity(id: 1, content: "신규 기능 개발", status: .uncertified, thumbnailStatus: .done),
            TodoEntity(id: 2, content: "치킨 먹기", status: .uncertified, thumbnailStatus: .done, certificationContent: "치킨 냠냠", reviewFeedback: ""),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .uncertified, thumbnailStatus: .done, reviewFeedback: "test"),
            TodoEntity(id: 2, content: "치킨 먹기", status: .uncertified, thumbnailStatus: .done, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.pending), thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.pending), thumbnailStatus: .yet, certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e.png"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.pending), thumbnailStatus: .yet, certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png"),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.approve), thumbnailStatus: .yet, certificationContent: "치킨 냠냠", certificationMediaUrl: "https://dogether-bucket-dev.s3.ap-northeast-2.amazonaws.com/daily-todo-proof-media/mock/e1.png"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.approve), thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.approve), thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.approve), thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.approve), thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.reject), thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.reject), thumbnailStatus: .yet, certificationContent: "치킨 냠냠"),
            TodoEntity(id: 1, content: "신규 기능 개발", status: .reviewed(.reject), thumbnailStatus: .yet),
            TodoEntity(id: 2, content: "치킨 먹기", status: .reviewed(.reject), thumbnailStatus: .yet, certificationContent: "치킨 냠냠")
        ])
    }
    
    func readTodo(todoId: String) async throws { }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws { }
}
