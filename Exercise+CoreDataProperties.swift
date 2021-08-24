//
//  Exercise+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/23/21.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var taskID: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var action: String?
    @NSManaged public var trainingAmount: Double
    @NSManaged public var resultBeforeTraining: Double
    @NSManaged public var resultAfterTraining: Double
    @NSManaged public var units: String?
    @NSManaged public var color: String?
    @NSManaged public var icon: String?
    @NSManaged public var parent: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var goal: Goal?
    
    
    private var wrappedTaskID: UUID {
        taskID ?? UUID()
    }
    
    private var wrappedDate: Date {
        date ?? Date()
    }
    
    private var wrappedAction: String {
        action ?? "Unknown Action"
        
    }
    
    private var wrappedUnits: String {
        units ?? "Unknown units"
    }
    
    private var wrappedColor: String {
        color ?? "brandBlue"
    }
    
    private var wrappedIcon: String {
        icon ?? "book"
    }
    
    private var wrappedParent: UUID {
        parent ?? UUID()
        
    }
    
    private var wrappedGoal: Goal {
        goal ?? Goal()
    }

}

extension Exercise : Identifiable {

}
