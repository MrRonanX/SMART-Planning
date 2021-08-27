//
//  Goal+CoreDataClass.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/24/21.
//
//

import Foundation
import CoreData

@objc(Goal)
public class Goal: NSManagedObject {
    
    var wrappedID: UUID {
        id ?? UUID()
    }
    
    var notificationHour: Int {
        notification?.wrappedHour ?? 0
    }
    
    var notificationMinute: Int {
        notification?.wrappedMinute ?? 0
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
        trainingDays?.compactMap { Int($0) } ?? [0]
    }
    
    var wrappedTasks: [Exercise] {
        tasks?.sorted { $0.wrappedDate < $1.wrappedDate } ?? []
    }
    
    var wrappedNotification: NotificationTime {
        notification ?? NotificationTime()
    }
    
    var wrappedUnitsShort: String {
        unitsShort ?? "$"
    }
}


public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

