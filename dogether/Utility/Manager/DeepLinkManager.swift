//
//  DeepLinkManager.swift
//  dogether
//
//  Created by yujaehong on 12/27/25.
//

import Foundation

final class DeepLinkManager {
    static let shared = DeepLinkManager()

    private var pendingInviteCode: String?
    
    func resolveUrl(userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        pendingInviteCode = code
    }

    func consumeInviteCode() -> String? {
        defer { pendingInviteCode = nil }
        return pendingInviteCode
    }
}
