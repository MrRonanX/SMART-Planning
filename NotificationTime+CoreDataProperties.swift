//
//  NotificationTime+CoreDataProperties.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//
//

import Foundation
import CoreData


extension NotificationTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationTime> {
        return NSFetchRequest<NotificationTime>(entityName: "NotificationTime")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
    @NSManaged public var goal: Goal?

}
