//
//  ProfileEntity.swift
//  dogether
//
//  Created by seungyooooong on 7/20/25.
//

import Foundation

struct ProfileEntity: BaseEntity {
    let name: String
    let imageUrl: String
    
    init(name: String = "", imageUrl: String = "") {
        self.name = name
        self.imageUrl = imageUrl
    }
}
