//
//  TimelineView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var brain: GoalsManager
    @State private var detailView: GoalModel? = nil
    @State var showAddGoalsView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(brain.goals) { goalModel in
                            GoalViewCell(goalModel: goalModel, size: geo.size.width)
                                .onTapGesture { detailView = goalModel }
                        }
                        Spacer()
                    }
                }
            }
            .fullScreenCover(item: $detailView) { model in GoalDetailView(goal: model)}
            .onAppear(perform: setNotifications)
            .fullScreenCover(isPresented: $showAddGoalsView, onDismiss: setNotifications) { ChooseGoalView (launchedByMainScreen: $showAddGoalsView) }
            .navigationTitle("Goal Timelines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addGoals) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addGoals() {
        showAddGoalsView = true
        //        NotificationManager.shared.listScheduledNotifications()
    }
    
    private func setNotifications() {
        brain.loadData()
        let notificationManager = NotificationManager.shared
        notificationManager.notifications = brain.createNotificationObjects()
        notificationManager.schedule()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //            notificationManager.listScheduledNotifications()
        //        }
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}


struct ScrollViewIfNeeded<Content: View>: View {
    
    var numberOfGoals: Int
    var content: Content
    
    init(numberOfGoals: Int, @ViewBuilder content: @escaping () -> Content) {
        self.numberOfGoals = numberOfGoals
        self.content = content()
    }
    
    var body: some View {
        if numberOfGoals > 4 {
            ScrollView(showsIndicators: false) {
                content
            }
        } else {
            content
        }
    }
}





