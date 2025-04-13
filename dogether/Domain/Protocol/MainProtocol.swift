//
//  MainProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/7/25.
//

import Foundation
import Combine

protocol MainProtocol {
    var isLoadingPublisher: CurrentValueSubject<Bool, Never> { get }
    func getGroupStatus() async throws -> GetGroupStatusResponse
    func getGroupInfo() async throws -> GetGroupInfoResponse
    func getTeamSummary() async throws -> GetTeamSummaryResponse
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse
}
