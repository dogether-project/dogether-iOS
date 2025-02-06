//
//  CreateTodosRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct CreateTodosRequest: Todos, Encodable {
    let todos: [String]
}
