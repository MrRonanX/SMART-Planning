//
//  NotificationSettingViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/22/21.
//

import Foundation

extension NotificationSettings {
    final class NotificationSettingsViewModel: ObservableObject {
        
        @Published var notificationTime = Date()
        @Published var goal: GoalModel
        @Published var notificationIsOn: Bool {
            didSet {
                goal.goal.allowNotifications = notificationIsOn
                if notificationIsOn { setNotificationTime(notificationTime) }
            }
        }
        
        
        var status: String {
            notificationIsOn ? "on" : "off"
        }
        
        
        init(goal: GoalModel) {
            self.goal = goal
            notificationIsOn =  goal.goal.allowNotifications
            guard notificationIsOn else { return }
            notificationTime = Calendar.current.date(from: DateComponents(hour: goal.goal.notification?.wrappedHour, minute: goal.goal.notification?.wrappedMinute)) ?? Date()
        }
        
        
        func setNotificationTime(_ time: Date) {
            let hour = Calendar.current.component(.hour, from: time)
            let minute = Calendar.current.component(.minute, from: time)
            
            var notification = goal.goal.notification
            if notification == nil {
                notification = NotificationTime(context: PersistenceManager.shared.viewContext)
            }
            
            notification?.hour = Int16(hour)
            notification?.minute = Int16(minute)
            
            if notification?.goal == nil {
                goal.goal.notification = notification
            }
        }
    }
}
