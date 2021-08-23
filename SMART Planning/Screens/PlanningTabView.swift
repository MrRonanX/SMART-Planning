//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

final class AppsViewModel: ObservableObject {
    @Published var goals = [GoalModel]()
    
    func loadGoals() {
        goals = PersistenceManager.shared.getAllGoals().map { GoalModel(
            id                  : $0.wrappedID,
            name                : $0.wrappedTitle,
            daysOfPractice      : $0.wrappedDaysOfPractice,
            baseProgress        : $0.baseProgress,
            practiceAction      : $0.wrappedAction,
            goalIcon            : $0.wrappedIcon,
            goalColor           : $0.wrappedColor,
            desiredResult       : $0.desiredResult,
            measurableUnits     : $0.wrappedUnits,
            trainingDays        : $0.wrappedTrainingDays,
            startDate           : $0.wrappedStartDate,
            deadline            : $0.wrappedDeadline,
            notificationHour    : $0.wrappedNotificationHour,
            notificationMinute  : $0.wrappedNotificationMinute
        )}
    }
}

struct PlanningTabView: View {
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
                    Text("Weekly Tasks")
                }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
    }
}

struct PlanningTabView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningTabView()
    }
}
