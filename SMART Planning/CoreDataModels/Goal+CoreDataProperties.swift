//
//  Goal+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/12/21.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var action: String?
    @NSManaged public var color: String?
    @NSManaged public var icon: String?
    @NSManaged public var notificationHour: Int16
    @NSManaged public var notificationMinute: Int16
    @NSManaged public var title: String?
    @NSManaged public var daysOfPracticeAWeek: Int16
    @NSManaged public var desiredResult: Double
    @NSManaged public var currentProgress: Double
    @NSManaged public var baseProgress: Double
    @NSManaged public var goalDescription: String?
    @NSManaged public var units: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var trainingDays: NSSet?
    
    
}

// MARK: Generated accessors for trainingDays
extension Goal {

    @objc(addTrainingDaysObject:)
    @NSManaged public func addToTrainingDays(_ value: TrainingDays)

    @objc(removeTrainingDaysObject:)
    @NSManaged public func removeFromTrainingDays(_ value: TrainingDays)

    @objc(addTrainingDays:)
    @NSManaged public func addToTrainingDays(_ values: NSSet)

    @objc(removeTrainingDays:)
    @NSManaged public func removeFromTrainingDays(_ values: NSSet)

}

extension Goal : Identifiable {

}
