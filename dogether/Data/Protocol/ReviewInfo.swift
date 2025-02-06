//
//  ReviewInfo.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

protocol ReviewInfo {
    var id: Int { get }
    var content: String { get }
    var mediaUrls: [String] { get }
    var todoContent: String { get }
}
