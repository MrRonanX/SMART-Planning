//
//  Goal+CoreDataClass.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/12/21.
//
//

import Foundation
import CoreData

@objc(Goal)
public class Goal: NSManagedObject {
    
    var wrappedID: UUID {
        id ?? UUID()
    }
    
    var wrappedNotificationHour: Int {
        Int(notificationHour)
    }
    
    var wrappedNotificationMinute: Int {
        Int(notificationMinute)
    }
    
    var wrappedAction: String {
        action ?? "Unknown action"
    }
    
    var wrappedColor: String {
        color ?? "brandBlue"
    }
    
    var wrappedIcon: String {
        icon ?? "book"
    }
    
    var wrappedTitle: String {
        title ?? "Unknown Goal"
    }
    
    var wrappedGoalDescription: String {
        goalDescription ?? "Unknown Description"
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
