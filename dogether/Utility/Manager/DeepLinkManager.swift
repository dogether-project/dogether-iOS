//
//  DeepLinkManager.swift
//  dogether
//
//  Created by yujaehong on 12/27/25.
//

import Foundation

final class DeepLinkManager {
    static let shared = DeepLinkManager()

    private(set) var pendingInviteCode: String?

    func handle(link: URL) {
        guard let components = URLComponents(url: link, resolvingAgainstBaseURL: false),
              let code = components.queryItems?
                .first(where: { $0.name == "code" })?.value
        else { return }

        pendingInviteCode = code
    }

    func consumeInviteCode() -> String? {
        defer { pendingInviteCode = nil }
        return pendingInviteCode
    }
}
