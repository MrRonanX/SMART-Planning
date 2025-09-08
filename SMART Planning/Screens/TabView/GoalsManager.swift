//
//  GoalsManager.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/30/21.
//

import Foundation
import SwiftData

@MainActor
final class GoalsManager: ObservableObject {
//    @Published var goals = [GoalModel]()
    
//    func loadData() {
//        guard let modelContext else { return }
//        let cdGoals = (try? modelContext.fetch(FetchDescriptor<Goal>())) ?? []
//        let cdGoalsIDs = cdGoals.map { $0.wrappedID }
//        let localGoalsID = goals.map { $0.goal.wrappedID }
//        guard cdGoalsIDs != localGoalsID else { return }
//        
//        var newGoals = cdGoals.map(GoalModel.init)
//        // Ensure tasks exist for each goal
//        for i in newGoals.indices {
//            newGoals[i].ensureTasks(using: modelContext)
//        }
//        goals = newGoals
//        tasks = goals.flatMap { $0.tasks }
//    }
//    
//    func createNotificationObjects() -> [ScheduledNotification] {
//        var notifications = [ScheduledNotification]()
//        for goal in goals {
//            guard goal.goal.allowNotifications else { continue }
//            let notification = ScheduledNotification(
//                id: goal.id,
//                title: goal,
//                action:  goal.goal.wrappedAction.lowercased(),
//                goal: goal.todayTask.roundToDecimal(2),
//                units: goal.goal.wrappedUnits.lowercased(),
//                trainingDays: goal.goal.wrappedTrainingDays,
//                hour: goal.goal.notificationHour,
//                minute: goal.goal.notificationMinute
//            )
//            notifications.append(notification)
//        }
//        
//        return notifications
//    }
}
