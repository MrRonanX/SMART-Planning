//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI


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
