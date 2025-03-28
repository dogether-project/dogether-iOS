//
//  GroupProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse
}
