//
//  GetMyTodosResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import Foundation

struct GetMyTodosResponse: Decodable {
    let todos: [TodoEntity]
}
