//
//  NetworkManager.swift
//  dogether
//
//  Created by seungyooooong on 1/27/25.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    weak var coordinator: NavigationCoordinator?
    
    func request<T: Decodable>(_ endpoint: NetworkEndpoint) async throws -> T {
        LoadingManager.shared.showLoading()
        defer { LoadingManager.shared.hideLoading() }
        
        do {
            let response: ServerResponse<T> = try await NetworkService.shared.request(endpoint)
            guard let data = response.data else { throw NetworkError.parse }
            return data
        } catch {
            throw mapError(error)
        }
    }
    
    func request(_ endpoint: NetworkEndpoint) async throws -> Void {
        LoadingManager.shared.showLoading()
        defer { LoadingManager.shared.hideLoading() }
        
        do {
            let _: ServerResponse<EmptyData> = try await NetworkService.shared.request(endpoint)
        } catch {
            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let error = error as? NetworkError {
            if case let .dogetherError(code, _) = error {
                switch code {
                case .CF0001, .ATF0001, .MF0001, .CGF0001, .DTF0001,
                        .DTCF0001, .DTHF0001, .MAF0001, .NF0001, .AIF0001:
                    // 일반적인 에러
                    break
                case .ATF0003:
                    coordinator?.showPopup(type: .alert, alertType: .needLogout) { [weak self] _ in
                        guard let self else { return }
                        // FIXME: logout 로직 임시 구현
                        UserDefaultsManager.shared.loginType = nil
                        UserDefaultsManager.shared.accessToken = nil
                        UserDefaultsManager.shared.userFullName = nil
                        coordinator?.setNavigationController(OnboardingViewController())
                    }
                    break
                default: break
                }
            }
            return error
        } else {
            // 일반적인 에러
            return NetworkError.unknown
        }
    }
}
