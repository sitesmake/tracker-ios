//
//  DaysFormatter.swift
//  Tracker
//
//  Created by alexander on 12.03.2025.
//

import Foundation

class DaysFormatter {
    private static let dateFormatter = DateFormatter()
    static let weekdays = Calendar.current.weekdaySymbols
    static func shortWeekday(at index: Int) -> String {
        dateFormatter.shortWeekdaySymbols[index]
    }
}
