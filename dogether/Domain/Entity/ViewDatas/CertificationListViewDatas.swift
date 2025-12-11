//
//  CertificationListViewDatas.swift
//  dogether
//
//  Created by yujaehong on 12/8/25.
//

import Foundation

struct CertificationListViewDatas: BaseEntity {
    var sections: [SectionEntity]
    
    var currentFilter: FilterTypes
    var selectedSortOption: SortOptions
    
    var currentPage: Int
    var isLastPage: Bool
    
    var viewStatus: CertificationListViewStatus
    
    init(
        sections: [SectionEntity] = [],
        currentFilter: FilterTypes = .all,
        selectedSortOption: SortOptions = .todoCompletionDate,
        currentPage: Int = 0,
        isLastPage: Bool = false,
        viewStatus: CertificationListViewStatus = .empty
    ) {
        self.sections = sections
        self.currentFilter = currentFilter
        self.selectedSortOption = selectedSortOption
        self.currentPage = currentPage
        self.isLastPage = isLastPage
        self.viewStatus = viewStatus
    }
}

enum SectionType: BaseEntity {
    case daily(dateString: String)
    case group(groupName: String)
}

struct SectionEntity: BaseEntity {
    let type: SectionType
    let todos: [TodoEntity]
}
