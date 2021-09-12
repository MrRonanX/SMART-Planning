//
//  Exercise+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var resultAfterTraining: Double
    @NSManaged public var resultBeforeTraining: Double
    @NSManaged public var taskID: UUID?
    @NSManaged public var trainingAmount: Double
    @NSManaged public var goal: Goal?

}

extension Exercise : Identifiable {

}
