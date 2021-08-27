//
//  TimelineView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var brain: GoalsManager
    
    @State var showAddGoalsView = false
    
    var body: some View {
        NavigationView {
            ScrollViewIfNeeded(numberOfGoals: brain.goals.count) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(brain.goals) { goalModel in
                        HStack {
                            Image(goalModel.goal.wrappedIcon)
                                .iconStyle(with: 30)
                                .foregroundColor(Color(goalModel.goal.wrappedColor))

                            Text(goalModel.goal.wrappedTitle)
                                .font(.title3)
                                .bold()
                        }
                        
                        StepperView(numberOfSteps: goalModel.numberOfSteps, topText: goalModel.dateText, completionStage: goalModel.indicators, bottomText: goalModel.goalText, itemSpacing: goalModel.spacing, itemColor: goalModel.goal.wrappedColor)
                            .padding(.bottom)
                    }
                    
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear(perform: setNotifications)
                .fullScreenCover(isPresented: $showAddGoalsView, onDismiss: setNotifications) { ChooseGoalView (launchedByMainScreen: $showAddGoalsView) }
                .navigationTitle("Goal Timelines")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddGoalsView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func setNotifications() {
        brain.loadData()
        let notificationManager = NotificationManager.shared
        notificationManager.notifications = brain.createNotificationObjects()
        notificationManager.schedule()
        notificationManager.listScheduledNotifications()
            
    }
    
    func loadGoals() {
        //        goals = PersistenceController.shared.getAllGoals().map { GoalModel(id: $0.wrappedID, name: $0.wrappedTitle, daily: $0.daily, daysOfPractice: $0.wrappedDaysOfPractice, baseProgress: $0.baseProgress, desiredResult: $0.desiredResult, mesurableUnits: $0.wrappedUnits, trainingDays: $0.wrappedTrainingDays, startDate: $0.wrappedStartDate , deadline: $0.wrappedDeadline)}
        
        brain.loadData()
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
            }} else {
                content
            }
    }
}








