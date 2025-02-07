//
//  TodosRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum TodosRouter: NetworkEndpoint {
    case createTodos(createTodosRequest: CreateTodosRequest)
    case certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest)
    case getMyYesterdayTodos
    
    var path: String {
        switch self {
        case .createTodos:
            return Path.api + Path.todos
        case .certifyTodo(let todoId, _):
            return Path.api + Path.todos + "/\(todoId)/certify"
        case .getMyYesterdayTodos:
            return Path.api + Path.todos + "/my/yesterday"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyYesterdayTodos:
            return .get
        case .createTodos, .certifyTodo:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + Header.Value.accessToken
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createTodos(let createTodosRequest):
            return createTodosRequest
        case .certifyTodo(_, let certifyTodoRequest):
            return certifyTodoRequest
        default:
            return nil
        }
    }
}
