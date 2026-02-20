//
//  StringExt.swift
//  dogether
//
//  Created by seungyooooong on 2/20/26.
//

import Foundation

extension String {
    func translateDateFormatForServer() -> String {
        self.split(separator: ".").joined(separator: "-")
    }
}
