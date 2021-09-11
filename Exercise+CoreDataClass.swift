//
//  Exercise+CoreDataClass.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/23/21.
//
//

import Foundation
import CoreData

@objc(Exercise)
public class Exercise: NSManagedObject {

    var wrappedTaskID: UUID {
        taskID ?? UUID()
    }
    
    var wrappedDate: Date {
        date ?? Date()
    }
    
    var action: String {
        goal?.wrappedAction ?? "Unknown Action"
        
    }
    
    var units: String {
        goal?.wrappedUnits ?? "Unknown units"
    }
    
    var color: String {
        goal?.wrappedColor ?? "brandBlue"
    }
    
    var icon: String {
        goal?.wrappedIcon ?? "book"
    }
    
    var wrappedGoal: Goal {
        goal ?? Goal()
    }
}

extension Exercise: Comparable {
    public static func < (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.wrappedDate < rhs.wrappedDate
    }
}
