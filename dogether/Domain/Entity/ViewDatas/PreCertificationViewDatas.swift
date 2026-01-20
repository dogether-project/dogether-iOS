//
//  PreCertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 1/19/26.
//

import Foundation

struct PreCertificationViewDatas: BaseEntity {
    let title: String
    let date: String?
    let groupId: Int?
    let memberId: Int?
    let todoId: Int?
    let sortOption: SortOptions?
    let filter: FilterTypes?
    
    init(
        title: String = "",
        date: String? = nil,
        groupId: Int? = nil,
        memberId: Int? = nil,
        todoId: Int? = nil,
        sortOption: SortOptions? = nil,
        filter: FilterTypes? = nil
    ) {
        self.title = title
        self.date = date
        self.groupId = groupId
        self.memberId = memberId
        self.todoId = todoId
        self.sortOption = sortOption
        self.filter = filter
    }
}
