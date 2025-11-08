//
//  ProfileViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/8/25.
//

import Foundation

struct ProfileViewDatas: BaseEntity {
    var name: String
    var imageUrl: String
    
    init(name: String = "", imageUrl: String = "") {
        self.name = name
        self.imageUrl = imageUrl
    }
}
