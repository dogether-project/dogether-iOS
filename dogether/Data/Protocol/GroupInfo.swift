//
//  GroupInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

protocol GroupInfo {
    var groupName: String { get }
    var memberCount: Int { get }
    var dailyTodoLimit: Int { get }
}
