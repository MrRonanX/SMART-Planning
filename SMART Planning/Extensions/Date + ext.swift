//
//  Date + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/29/21.
//

import Foundation

extension Date {
    
    enum DateFormat: String {
        case stepper = "MMM d"
        case list = "E, MMM d"
        case deadline = "MMMM d, y"
    }
    
    func toString(_ format: DateFormat = .stepper) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format.rawValue
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func days(from beginning: Date) -> Int {
        Calendar.current.dateComponents([.day], from: beginning, to: self).day!
    }
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func adding(weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
    
    var startOfWeek: Date {
        if let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) {
            let dslTimeOffset = TimeZone.current.daylightSavingTimeOffset(for: date)
            return date.addingTimeInterval(dslTimeOffset)
        }
        print("Error date")
        return Date()
    }
}
