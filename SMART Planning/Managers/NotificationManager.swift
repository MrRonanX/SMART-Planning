//
//  NotificationManager.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()
    var notifications = [GoalModel]()
    
    private init() {}
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            if granted == true && error == nil {
                self.scheduleNotification()
            }
           
            
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotification()
                break
            default:
                break
            }
        }
    }
    
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func scheduleNotification() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.name
            content.body = "Did you \(notification.practiceAction.lowercased()) \(notification.dailyGoal.roundToDecimal(2)) \(notification.measurableUnits.lowercased()) today?"
            content.categoryIdentifier = "SMART Planning"
            // TODO: - encode actual task
            let taskData = try? JSONEncoder().encode(notification)
            if let taskData = taskData {
                content.userInfo = ["Goal": taskData]
            }
            
            let date = notificationDate(for: notification)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            content.threadIdentifier = "CalendarBasedNotificationThreadId"
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }

    }
    
    
    private func notificationDate(for goal: GoalModel) -> DateComponents {
        var correctDate = Date()
        
        if correctDate.hour() >= goal.notificationHour && correctDate.minute() >= goal.notificationMinute {
            correctDate = correctDate.adding(days: 1)
        }
        
        let weekDay = Calendar.current.component(.weekday, from: correctDate)
        
        while !goal.trainingDays.contains(weekDay) {
            correctDate = correctDate.adding(days: 1)
        }
        
        let year = correctDate.year()
        let month = correctDate.month()
        let day = correctDate.day()
        
        return DateComponents(calendar: .current, timeZone: .current, year: year, month: month, day: day, hour: goal.notificationHour, minute: goal.notificationMinute)
    }
}
