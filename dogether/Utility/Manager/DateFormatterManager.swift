//
//  DateFormatterManager.swift
//  dogether
//
//  Created by seungyooooong on 2/11/25.
//

import Foundation

struct DateFormatterManager {
    static func formattedDate(_ days: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let returnDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return formatter.string(from: returnDate)
    }
}
