//
//  GoalsManager.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/30/21.
//

import Foundation

final class GoalsManager: ObservableObject {
    @Published var goals = [GoalModel]()
    @Published var tasks = [Exercise]()
    
    private let container = PersistenceManager.shared
    
    func loadData() {
        goals = PersistenceManager.shared.getAllGoals().map(GoalModel.init)
        tasks = goals.flatMap { $0.tasks }
    }
    
    func createNotificationObjects() -> [ScheduledNotification] {
        var notifications = [ScheduledNotification]()
        for goal in goals {
            guard goal.goal.allowNotifications else { continue }
            let notification = ScheduledNotification(id: goal.goal.wrappedID,
                                                     title: goal.goal.wrappedTitle,
                                                     action:  goal.goal.wrappedAction.lowercased(),
                                                     goal: goal.todayTask.roundToDecimal(2),
                                                     units: goal.goal.wrappedUnits.lowercased(),
                                                     trainingDays: goal.goal.wrappedTrainingDays,
                                                     hour: goal.goal.notificationHour,
                                                     minute: goal.goal.notificationMinute)
            notifications.append(notification)
        }
        
        return notifications
    }
}
