//
//  Date + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/29/21.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String = "MMM d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func adding(weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
}
