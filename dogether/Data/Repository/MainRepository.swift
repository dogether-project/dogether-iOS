//
//  MainRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation
import Combine

final class MainRepository: MainProtocol {
    private let groupsDataSource: GroupsDataSource
    private let todosDataSource: TodosDataSource
    private let networkService: NetworkService
    
    init(
        groupsDataSource: GroupsDataSource = .shared,
        todosDataSource: TodosDataSource = .shared,
        networkService: NetworkService = .shared
    ) {
        self.groupsDataSource = groupsDataSource
        self.todosDataSource = todosDataSource
        self.networkService = networkService
    }
    
    var isLoadingPublisher: CurrentValueSubject<Bool, Never> {
        networkService.isLoading
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
