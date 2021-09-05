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
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(brain.goals) { goalModel in
                        GoalViewCell(goalModel: goalModel)
                            .onTapGesture { detailView = goalModel }
                            
                    }
                    Spacer()
                }
                .padding(.horizontal)

            }
            .sheet(item: $detailView) { model in GoalDetailView(goal: model)}
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


struct GoalDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var brain: GoalsManager
    var goal: GoalModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Objective")) {
                    Text(goal.goal.wrappedTitle)
                    Text(goal.goal.wrappedGoalDescription)
                }
                
                Section(header: Text("Progress")) {
                    Text("Start with: \(goal.goal.baseProgress, specifier: "%2g") \(goal.goal.wrappedUnits)")
                    Text("Desired result: \(goal.goal.desiredResult, specifier: "%2g") \(goal.goal.wrappedUnits)")
                    Text("Current progress: \(goal.goal.currentProgress, specifier: "%.2f") \(goal.goal.wrappedUnits)")
                    Text("Average training per day: \(goal.dailyGoal, specifier: "%.2f") \(goal.goal.wrappedUnits)")
                }
                
                Section(header: Text("Time frame")) {
                    Text("Start date: \(goal.goal.wrappedStartDate.toString(.deadlineNextYear))")
                    Text("Deadline: \(goal.goal.wrappedDeadline.toString(.deadlineNextYear))")
                }
                
                Button(action: deleteGoal) {
                    Text("Delete")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle(goal.goal.wrappedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismissView)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit", action: editButtonPressed)
                }
                
            }
        }
    }
    
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func editButtonPressed() {
        print("Edit Pressed")
    }
    
    
    func deleteGoal() {
        brain.goals.removeAll(where: {$0.goal.wrappedID == goal.goal.wrappedID })
        NotificationManager.shared.cancelNotification(with: goal.goal.wrappedID)
        PersistenceManager.shared.deleteGoal(goal.goal)
        dismissView()
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
