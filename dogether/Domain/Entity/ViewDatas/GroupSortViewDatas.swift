//
//  GroupSortViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/26/25.
//

struct GroupSortViewDatas: BaseEntity {
    var options: [GroupSortOption]
    var selected: GroupSortOption?

    init(
        options: [GroupSortOption] = [],
        selected: GroupSortOption? = nil
    ) {
        self.options = options
        self.selected = selected
    }
}

struct GroupSortOption: BottomSheetItemRepresentable, Hashable {
    let groupId: Int
    let groupName: String
    
    var displayName: String {
        return groupName
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}

