//
//  Identifier.swift
//  dogether
//
//  Created by 박지은 on 2/13/25.
//

import Foundation

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension ReusableProtocol {
    static var identifier : String {
        return String(describing: self)
    }
}
