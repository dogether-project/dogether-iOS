//
//  GetMyYesterdayTodosResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetMyYesterdayTodosResponse: Todos, Decodable {
    let todos: [String]
}
