//
//  MainRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/12/25.
//

import Foundation

final class MainRepositoryTest: MainProtocol {
    func getGroupStatus() async throws -> GetGroupStatusResponse {
//        return GetGroupStatusResponse(status: "READY")
        return GetGroupStatusResponse(status: "RUNNING")
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        return GetGroupInfoResponse(
            name: "Test Group Name",
            duration: 3,
            joinCode: "000000",
            maximumTodoCount: 10,
            endAt: "25.01.01",
            remainingDays: 2
        )
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        let rankings = (1 ... 20).map { RankingModel(rank: $0, name: "testName \($0)", certificationRate: Double($0)) }
        return GetTeamSummaryResponse(ranking: rankings)
    }
    
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
