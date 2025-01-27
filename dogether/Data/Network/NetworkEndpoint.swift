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
    var serverURL: URL? { URL(string: "dogether.domain.site") }    // TODO: 추후 dogether domain으로 수정
    // MARK: - APIs
    case test   // TODO: 추후 테스트 API 또는 실 API로 수정
    
    // MARK: - path
    var path: String {
        switch self {
        case .test:
            return "/test"
        }
    }
    
    // MARK: - method
    var method: NetworkMethod {
        switch self {
        case .test:
            return .get
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
        default:
            return nil
        }
    }
    
    // MARK: - body
    var body: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
}
