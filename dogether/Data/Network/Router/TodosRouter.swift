//
//  TodosRouter.swift
//  dogether
//
//  Created by seungyooooong on 1/2/26.
//

import Foundation

enum TodosRouter: NetworkEndpoint {
    case certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest)
    case remindTodo(todoId: String, remindTodoRequest: RemindTodoRequest)
    
    var path: String {
        switch self {
        case .certifyTodo(let todoId, _):
            return Path.api + Path.v1 + Path.todos + "/\(todoId)/certify"
        case .remindTodo(let todoId, _):
            return Path.api + Path.v1 + Path.todos + "\(todoId)/reminders"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .certifyTodo, .remindTodo:
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
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .certifyTodo(_, let certifyTodoRequest):
            return certifyTodoRequest
        case .remindTodo(_, let remindTodoRequest):
            return remindTodoRequest
        }
    }
}
