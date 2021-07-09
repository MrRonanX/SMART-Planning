//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

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
            WeeklyPerformance()
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
