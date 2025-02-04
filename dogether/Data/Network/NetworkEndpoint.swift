//
//  NetworkEndpoint.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

protocol NetworkEndpoint {
    var serverURL: URL? { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: Encodable? { get }
}

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ServerEndpoint: NetworkEndpoint {
    var serverURL: URL? { URL(string: "https://api-dev.dogether.site") }
    // MARK: - APIs
    case appleLogin(appleLoginRequest: AppleLoginRequest)
    case withdraw(withdrawRequest: WithdrawRequest)
    case createGroup(createGroupRequest: CreateGroupRequest)
    case joinGroup(joinGroupRequest: JoinGroupRequest)
    case getGroupInfo
    case getMySummary
    case getTeamSummary
    case createTodos(createTodosRequest: CreateTodosRequest)
    case certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest)
    case getMyYesterdayTodos
    
    // MARK: - path
    var path: String {
        switch self {
        case .appleLogin:
            return "/api/auth/login"
        case .withdraw:
            return "/api/auth/withdraw"
        case .createGroup:
            return "/api/groups"
        case .joinGroup:
            return "/api/groups/join"
        case .getGroupInfo:
            return "/api/groups/info/current"
        case .getMySummary:
            return "/api/groups/summary/my"
        case .getTeamSummary:
            return "/api/groups/summary/team"
        case .createTodos:
            return "/api/todos"
        case .certifyTodo(let todoId, _):
            return "/api/todos/\(todoId)/certify"
        case .getMyYesterdayTodos:
            return "/api/todos/my/yesterday"
        }
    }
    
    // MARK: - method
    var method: NetworkMethod {
        switch self {
        case .getGroupInfo,
                .getMySummary,
                .getTeamSummary,
                .getMyYesterdayTodos:
            return .get
        case .appleLogin,
                .createGroup,
                .joinGroup,
                .createTodos,
                .certifyTodo:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    // MARK: - parameters
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - header
    var header: [String : String]? {
        switch self {
        case .appleLogin:
            return ["Content-Type": "application/json"]
        case .withdraw,
                .createGroup,
                .joinGroup,
                .getGroupInfo,
                .getMySummary,
                .getTeamSummary,
                .createTodos,
                .certifyTodo,
                .getMyYesterdayTodos:
//            guard let accessToken: String = UserDefaultManager.accessToken else { return nil }    // TODO: 추후 accessToken 관리 부분 추가
            return ["Content-Type": "application/json", "Authorization": "Bearer " + "accessToken"]
        }
    }
    
    // MARK: - body
    var body: (any Encodable)? {
        switch self {
        case .appleLogin(let appleLoginRequest):
            return appleLoginRequest
        case .withdraw(let withdrawRequest):
            return withdrawRequest
        case .createGroup(let createGroupRequest):
            return createGroupRequest
        case .joinGroup(let joinGroupRequest):
            return joinGroupRequest
        case .createTodos(let createTodosRequest):
            return createTodosRequest
        case .certifyTodo(_, let certifyTodoRequest):
            return certifyTodoRequest
        default:
            return nil
        }
    }
}
