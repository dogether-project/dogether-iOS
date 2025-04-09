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
        await MainActor.run {
            LoadingEventBus.shared.show()
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000) 
        
        defer {
            Task { @MainActor in
                LoadingEventBus.shared.hide()
            }
        }
        
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
        await MainActor.run {
            LoadingEventBus.shared.show()
        }
        
        defer {
            Task { @MainActor in
                LoadingEventBus.shared.hide()
            }
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let rankings = (1 ... 20).map { RankingModel(rank: $0, name: "testName \($0)", certificationRate: Double($0)) }
        return GetTeamSummaryResponse(ranking: rankings)
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        return GetMyTodosResponse(todos: [])
    }
}
