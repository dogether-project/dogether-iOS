//
//  TotalCount.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

protocol TotalCount {
    var totalTodoCount: Int { get }
    var totalCertificatedCount: Int { get }
    var totalApprovedCount: Int { get }
}
