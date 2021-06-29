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
}
