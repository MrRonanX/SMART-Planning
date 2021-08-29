//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

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


struct PlanningTabView: View {
    @StateObject var brain = GoalsManager()
    
    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Image(systemName: "clock.arrow.2.circlepath")
                    Text("Timelines")
                }
            DailyTasksView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Daily Tasks")
                }
            PerformanceView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Progress")
                }
        }
        .environmentObject(brain)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
    }
}

struct PlanningTabView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningTabView()
    }
}
