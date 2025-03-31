//
//  MainRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation

final class MainRepository: MainProtocol {
    private let groupsDataSource: GroupsDataSource
    private let todosDataSource: TodosDataSource
    
    init(
        groupsDataSource: GroupsDataSource = .shared,
        todosDataSource: TodosDataSource = .shared
    ) {
        self.groupsDataSource = groupsDataSource
        self.todosDataSource = todosDataSource
    }
    
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        try await groupsDataSource.getGroupStatus()
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        try await groupsDataSource.getGroupInfo()
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        try await groupsDataSource.getTeamSummary()
    }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await todosDataSource.getMyTodos(date: date, status: status)
    }
}
