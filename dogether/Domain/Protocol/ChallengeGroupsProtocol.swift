//
//  ChallengeGroupsProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

protocol ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws
    func getMyTodos(groupId: String, date: String) async throws -> [TodoEntity]
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, isMine: Bool, todos: [TodoEntity])
    func readTodo(todoHistoryId: String) async throws
}
