//
//  Goal+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var action: String?
    @NSManaged public var baseProgress: Double
    @NSManaged public var color: String?
    @NSManaged public var currentProgress: Double
    @NSManaged public var daysOfPracticeAWeek: Int16
    @NSManaged public var deadline: Date?
    @NSManaged public var desiredResult: Double
    @NSManaged public var goalDescription: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var units: String?
    @NSManaged public var trainingDays: [Int16]?
    @NSManaged public var allowNotifications: Bool
    @NSManaged public var tasks: Set<Exercise>?
    @NSManaged public var notification: NotificationTime?

}

// MARK: Generated accessors for tasks
extension Goal {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Exercise)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Exercise)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Goal : Identifiable {

}
