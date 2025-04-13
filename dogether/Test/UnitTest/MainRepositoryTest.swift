//
//  MainRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/12/25.
//

import Foundation
import Combine

final class MainRepositoryTest: MainProtocol {
    var isLoadingPublisher: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        //        return GetGroupStatusResponse(status: "READY")
        return GetGroupStatusResponse(status: "RUNNING")
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        await simulateLoading(seconds: 3)
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
        await simulateLoading(seconds: 2)
        let rankings = (1 ... 20).map { RankingModel(rank: $0, name: "testName \($0)", certificationRate: Double($0)) }
        return GetTeamSummaryResponse(ranking: rankings)
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        await simulateLoading(seconds: 1)
        let todos: [TodoInfo] = [
              TodoInfo(id: 1, content: "", status: ""),
              TodoInfo(id: 2, content: "", status: ""),
              TodoInfo(id: 3, content: "", status: ""),
              TodoInfo(id: 4, content: "", status: "")
          ]
        return GetMyTodosResponse(todos: todos)
    }
    
    private func simulateLoading(seconds: Int) async {
        isLoadingPublisher.send(true) // 로딩 시작
        defer {
            isLoadingPublisher.send(false) // 로딩 종료
        }
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
