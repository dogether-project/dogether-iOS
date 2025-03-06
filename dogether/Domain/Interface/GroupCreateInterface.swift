//
//  GroupCreateInterface.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupCreateInterface {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse
}
