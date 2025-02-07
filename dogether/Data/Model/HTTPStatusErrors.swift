//
//  HTTPStatusErrors.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum HTTPStatusErrors: Int, Error {
    case unknown = 0
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    
    var description: String {
        switch self {
        case .unknown:
            ""
        case .badRequest:
            "잘못된 요청"
        case .unAuthorized:
            "비인증 상태"
        case .forbidden:
            "권한 거부"
        case .notFound:
            "존재하지 않는 요청 리소스"
        case .serverError:
            "서버 에러"
        }
    }
}
