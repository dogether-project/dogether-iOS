//
//  ChallengeGroupsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum ChallengeGroupsRouter: NetworkEndpoint {
    case createTodos(createTodosRequest: CreateTodosRequest)
    case certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest)
    case getMyTodos(date: String, status: TodoStatus?)
    case getMyYesterdayTodos
    case getMemberTodos(groupId: String, memberId: String)
    
    var path: String {
        switch self {
        case .createTodos:
            return Path.api + Path.challengeGroups
        case .certifyTodo(let todoId, _):
            return Path.api + Path.challengeGroups + "/\(todoId)/certify"
        case .getMyTodos:
            return Path.api + Path.challengeGroups + "/my"
        case .getMyYesterdayTodos:
            return Path.api + Path.challengeGroups + "/my/yesterday"
        case .getMemberTodos(let groupId, let memberId):
            return Path.api + Path.challengeGroups + "/\(groupId)/challenge-group-members/\(memberId)/today-todo-history"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyTodos, .getMyYesterdayTodos, .getMemberTodos:
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
