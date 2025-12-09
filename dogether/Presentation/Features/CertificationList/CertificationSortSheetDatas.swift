//
//  CertificationSortSheetDatas.swift
//  dogether
//
//  Created by yujaehong on 12/9/25.
//

import Foundation

/// 인증 목록 바텀시트용 데이터 모델
struct CertificationSortSheetDatas: BaseEntity {
    let items: [CertificationSortOption]
    var selected: CertificationSortOption
    
    init(
        items: [CertificationSortOption] = CertificationSortOption.allCases,
        selected: CertificationSortOption = .todoCompletionDate
    ) {
        self.items = items
        self.selected = selected
    }
}
