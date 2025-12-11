//
//  CertificationListViewDatas.swift
//  dogether
//
//  Created by yujaehong on 12/8/25.
//

import Foundation

struct CertificationListViewDatas: BaseEntity {
    var sections: [CertificationSection]
    
    var totalCertificatedCount: Int
    var totalApprovedCount: Int
    var totalRejectedCount: Int
    
    var currentFilter: FilterTypes
    var selectedSortOption: SortOptions
    
    var currentPage: Int
    var isLastPage: Bool
    
    var viewStatus: CertificationListViewStatus
    
    init(
        sections: [CertificationSection] = [],
        totalCertificatedCount: Int = 0,
        totalApprovedCount: Int = 0,
        totalRejectedCount: Int = 0,
        currentFilter: FilterTypes = .all,
        selectedSortOption: SortOptions = .todoCompletionDate,
        currentPage: Int = 0,
        isLastPage: Bool = false,
        viewStatus: CertificationListViewStatus = .empty
    ) {
        self.sections = sections
        self.totalCertificatedCount = totalCertificatedCount
        self.totalApprovedCount = totalApprovedCount
        self.totalRejectedCount = totalRejectedCount
        self.currentFilter = currentFilter
        self.selectedSortOption = selectedSortOption
        self.currentPage = currentPage
        self.isLastPage = isLastPage
        self.viewStatus = viewStatus
    }
}
