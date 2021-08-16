//
//  TimelineView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI

struct TimelineView: View {
    
    @State var goals: [GoalModel] = []
    @State var showAddGoalsView = false
    
    var body: some View {
        NavigationView {
            ScrollViewIfNeeded(numberOfGoals: goals.count) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(goals) { goal in
                        HStack {
                            Image(goal.goalIcon)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(goal.goalColor))
                            
                            Text(goal.name)
                                .font(.title3)
                                .bold()
                        }
                        
                        ProgressView(numberOfSteps: goal.numberOfSteps, topText: goal.dateText, completionStage: goal.indicators, bottomText: goal.goalText, itemSpacing: goal.spacing, itemColor: goal.goalColor)
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    NavigationLink(destination: ChooseGoalView (launchedByMainScreen: $showAddGoalsView), isActive: $showAddGoalsView) { EmptyView()}
                }.onAppear(perform: loadGoals)
                
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
    }
    
    func loadGoals() {
        //        goals = PersistenceController.shared.getAllGoals().map { GoalModel(id: $0.wrappedID, name: $0.wrappedTitle, daily: $0.daily, daysOfPractice: $0.wrappedDaysOfPractice, baseProgress: $0.baseProgress, desiredResult: $0.desiredResult, mesurableUnits: $0.wrappedUnits, trainingDays: $0.wrappedTrainingDays, startDate: $0.wrappedStartDate , deadline: $0.wrappedDeadline)}
        
        goals = MocGoals.goals
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






