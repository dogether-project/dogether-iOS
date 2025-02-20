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
    case getMyTodos(date: String, status: TodoStatus?)
    case getMyYesterdayTodos
    
    var path: String {
        switch self {
        case .createTodos:
            return Path.api + Path.todos
        case .certifyTodo(let todoId, _):
            return Path.api + Path.todos + "/\(todoId)/certify"
        case .getMyTodos:
            return Path.api + Path.todos + "/my"
        case .getMyYesterdayTodos:
            return Path.api + Path.todos + "/my/yesterday"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyTodos, .getMyYesterdayTodos:
            return .get
        case .createTodos, .certifyTodo:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getMyTodos(let date, let status):
            var parameters: [URLQueryItem] = [.init(name: "date", value: date)]
            if let status { parameters.append(.init(name: "status", value: status.rawValue)) }
            return parameters
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
