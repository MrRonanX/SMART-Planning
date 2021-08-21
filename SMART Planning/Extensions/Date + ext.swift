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
        case deadline = "MMMM d"
        case deadlineNextYear = "MMMM d, y"
        case year = "y"
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
    
    
    func isDateThisYear(_ date: Date) -> Bool {
        date.toString(.year) == self.toString(.year)
    }
    
    
    var startOfWeek: Date {
        if let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) {
            let startOfWeekNoon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
            let dslTimeOffset = TimeZone.current.daylightSavingTimeOffset(for: date)
            return startOfWeekNoon.addingTimeInterval(dslTimeOffset)
        }
        print("Error date")
        return Date()
    }
    
    
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
    
    
    func month(using calendar: Calendar = .current) -> Int {
        calendar.component(.month, from: self)
    }
    
    
    func datesOfMoths() -> [Date] {
        let year = self.year()
        let month = self.month()
        let currentTime = Calendar.current.component(.hour, from: self)
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        let dates = range.compactMap { day -> Date? in
            let date = DateComponents(calendar: .current, timeZone: .current, year: year, month: month, day: day, hour: currentTime)
            return Calendar.current.date(from: date)
        }
        return dates
    }
}
