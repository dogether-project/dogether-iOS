//
//  TodoProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

protocol TodoProtocol {
    func createTodos(createTodosRequest: CreateTodosRequest) async throws
}
