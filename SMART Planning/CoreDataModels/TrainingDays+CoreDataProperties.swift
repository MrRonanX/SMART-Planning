//
//  TrainingDays+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/12/21.
//
//

import Foundation
import CoreData


extension TrainingDays {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingDays> {
        return NSFetchRequest<TrainingDays>(entityName: "TrainingDays")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var day: Int16
    @NSManaged public var goal: Goal?
    
    var wrappedID: UUID {
        id ?? UUID()
    }
    
    var wrappedDay: Int {
        Int(day)
    }
}

extension TrainingDays : Identifiable {

}
