//
//  NotificationTime+CoreDataClass.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//
//

import Foundation
import CoreData

@objc(NotificationTime)
public class NotificationTime: NSManagedObject {
    
    var wrappedHour: Int {
        Int(hour)
    }
    
    var wrappedMinute: Int {
        Int(minute)
    }
}
