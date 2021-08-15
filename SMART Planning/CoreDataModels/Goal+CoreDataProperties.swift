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
    @NSManaged public var title: String?
    @NSManaged public var daily: Bool
    @NSManaged public var daysOfPracticeAWeek: Int16
    @NSManaged public var desiredResult: Double
    @NSManaged public var baseProgress: Double
    @NSManaged public var goalDescription: String?
    @NSManaged public var units: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var trainingDays: NSSet?
    
    var wrappedID: UUID {
        id ?? UUID()
    }
    
    var wrappedTitle: String {
        title ?? "Unknown Goal"
    }
    
    var wrappedGoalDescription: String {
        goalDescription ?? "Unknown Descripion"
    }
    
    var wrappedDaysOfPractice: Int {
        Int(daysOfPracticeAWeek)
    }
    
    var wrappedUnits: String {
        units ?? "Unknown Units"
    }
    
    var wrappedStartDate: Date {
        startDate ?? Date()
    }
    
    var wrappedDeadline: Date {
        deadline ?? Date().adding(days: 1)
    }
    
    var wrappedTrainingDays: [Int] {
        let days = trainingDays as? Set<TrainingDays> ?? []
        
        return days.map { $0.wrappedDay }
    }
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
