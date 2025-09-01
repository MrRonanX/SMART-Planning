//
//  NotificationManager.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {

    static let shared = NotificationManager()
    var notifications = [ScheduledNotification]()
    
    private init() {}
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            if granted == true && error == nil {
                // Hop to the main actor for scheduling
                DispatchQueue.main.async {
                    self.scheduleNotification()
                }
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            switch settings.authorizationStatus {
            case .notDetermined:
                // Ensure main-actor isolation for subsequent actions
                DispatchQueue.main.async {
                    self.requestAuthorization()
                }
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    self.scheduleNotification()
                }
            default:
                break
            }
        }
    }
    
    func cancelNotification(with id: UUID) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }
    
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            
            print("😕😕😕 There are \(notifications.count) notifications")
            
//            for notification in notifications {
//                print(notification)
//            }
        }
    }
    
    private func scheduleNotification() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = "Did you \(notification.action) \(notification.goal) \(notification.units) today?"
            content.categoryIdentifier = "SMART Planning"
   
            let taskData = try? JSONEncoder().encode(notification)
            if let taskData = taskData {
                content.userInfo = ["Goal": taskData]
            }
            
            let date = notificationDate(for: notification)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            content.threadIdentifier = "CalendarBasedNotificationThreadId"
            
            let request = UNNotificationRequest(identifier: notification.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    
    private func notificationDate(for goal: ScheduledNotification) -> DateComponents {
        var correctDate = Date()
        
        if correctDate.hour() > goal.hour {
            correctDate = correctDate.adding(days: 1)
            
        } else if correctDate.hour() == goal.hour && correctDate.minute() >= goal.minute {
            correctDate = correctDate.adding(days: 1)
        }
        
        var weekDay = Calendar.current.component(.weekday, from: correctDate)

        while !goal.trainingDays.contains(weekDay) {
            correctDate = correctDate.adding(days: 1)
            weekDay = Calendar.current.component(.weekday, from: correctDate)
        }
        
        let year = correctDate.year()
        let month = correctDate.month()
        let day = correctDate.day()
        
        return DateComponents(calendar: .current, timeZone: .current, year: year, month: month, day: day, hour: goal.hour, minute: goal.minute)
    }
}


struct ScheduledNotification: Codable {
    var id          : UUID
    var title       : String
    var action      : String
    var goal        : Double
    var units       : String
    var trainingDays: [Int]
    var hour        : Int
    var minute      : Int
}
