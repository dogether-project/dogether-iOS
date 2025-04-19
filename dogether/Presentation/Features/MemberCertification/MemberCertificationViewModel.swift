//
//  MemberCertificationViewModel.swift
//  dogether
//
//  Created by seungyooooong on 4/10/25.
//

import Foundation

final class MemberCertificationViewModel {
    var memberInfo: RankingModel?
    
    private(set) var certifications: [String] = []
    private(set) var currentIndex: Int = 0
}
