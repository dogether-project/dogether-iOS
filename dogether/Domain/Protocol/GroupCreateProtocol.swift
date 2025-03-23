//
//  GroupCreateProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupCreateProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse
}
