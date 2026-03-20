//
//  PreCertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 1/19/26.
//

import Foundation

enum PreCertificationViewDatas: BaseEntity {
    case main(title: String, date: String, groupId: Int, todoId: Int, filter: FilterTypes)
    case ranking(title: String, groupId: Int, memberId: Int)
    case certificationList(title: String, todoId: Int, sortOption: SortOptions, filter: FilterTypes)
}
