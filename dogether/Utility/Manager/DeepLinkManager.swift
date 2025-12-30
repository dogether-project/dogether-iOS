//
//  DeepLinkManager.swift
//  dogether
//
//  Created by yujaehong on 12/27/25.
//

import Foundation

final class DeepLinkManager {

    static let shared = DeepLinkManager()
    
    func handle(link: URL, metadata: [String: Any]? = nil) {

        guard let components = URLComponents(
            url: link,
            resolvingAgainstBaseURL: false
        ) else { return }

        let code = components.queryItems?
            .first(where: { $0.name == "code" })?.value

        guard let code else { return }

        NotificationCenter.default.post(
            name: .didReceiveInviteCode,
            object: code
        )
    }
}
