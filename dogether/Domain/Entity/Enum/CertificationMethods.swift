//
//  CertificationMethods.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

enum CertificationMethods: Int {
    case select
    case shoot
    
    var title: String {
        switch self {
        case .select:
            return "사진 선택"
        case .shoot:
            return "사진 촬영"
        }
    }
    
    var image: UIImage {
        switch self {
        case .select:
            return .gallery
        case .shoot:
            return .camera
        }
    }
}
