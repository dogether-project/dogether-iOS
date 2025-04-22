//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import Foundation

enum CertificationListViewStatus {
    case empty
    case hasData
}

final class CertificationListViewModel {
    var certificationListViewStatus: CertificationListViewStatus = .empty
}
