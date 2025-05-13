//
//  NetworkEndpoint.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import Foundation

protocol NetworkEndpoint {
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

enum Path {
    static let api = "/api"
    
    static let auth = "/auth"
    static let groups = "/groups"
    static let challengeGroups = "/challenge-groups"
    static let todoCertifications = "/todo-certifications"
    static let notification = "/notification"
    static let s3 = "/s3"
    
    static let summary = "/summary"
    static let tokens = "/tokens"
    static let myActivity = "/my/activity"
}

enum Header {
    enum Key {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    enum Value {
        static let applicationJson = "application/json"
        static let bearer = "Bearer "
        static let accessToken = UserDefaultsManager.shared.accessToken ?? ""
    }
}
