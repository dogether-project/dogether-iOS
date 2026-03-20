//
//  ChallengeGroupsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum ChallengeGroupsRouter: NetworkEndpoint {
    case createTodos(groupId: String, createTodosRequest: CreateTodosRequest)
    case getMyTodos(groupId: String, date: String)
    case getMyYesterdayTodos
    case getMemberTodos(groupId: String, memberId: String)
    case readTodo(todoHistoryId: String)
    
    var path: String {
        switch self {
        case .createTodos(let groupId, _):
            return Path.api + Path.v1 + Path.challengeGroups + "/\(groupId)/todos"
        case .getMyTodos(let groupId, _):
            return Path.api + Path.v2 + Path.challengeGroups + "/\(groupId)/my-todos"
        case .getMyYesterdayTodos:
            return Path.api + Path.v1 + Path.challengeGroups + "/my/yesterday"
        case .getMemberTodos(let groupId, let memberId):
            return Path.api + Path.v2 + Path.challengeGroups + "/\(groupId)/challenge-group-members/\(memberId)/today-todo-history"
        case .readTodo(let todoHistoryId): // FIXME: 추후 TodoHistoryRouter 분리
            return Path.api + Path.v1 + Path.todoHistory + "/\(todoHistoryId)"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyTodos, .getMyYesterdayTodos, .getMemberTodos:
            return .get
        case .createTodos, .readTodo:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getMyTodos(_, let date):
            return [.init(name: "date", value: date)]
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createTodos(_, let createTodosRequest):
            return createTodosRequest
        default:
            return nil
        }
    }
}
