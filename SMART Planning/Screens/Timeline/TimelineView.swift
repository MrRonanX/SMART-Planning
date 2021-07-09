//
//  TimelineView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI
import StepperView

struct TimelineView: View {
    
    @State var goals: [GoalModel] = MocGoals.goals
    @State var showAddGoalsView = false
  
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ForEach(goals) { goal in
                    HStack {
                        Spacer()
                        Text(goal.name)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.bottom, 20)
                        Spacer()
                    }.padding(.bottom, 5)
                   
                        StepperView()
                            .addSteps(goal.steps)
                            .indicators(goal.indicators)
                            .stepIndicatorMode(StepperMode.horizontal)
                            .lineOptions(StepperLineOptions.rounded(2, 4, Colors.cyan.rawValue))
                            .stepLifeCycles(goal.lifeCycles)
                            .spacing(goal.spacing)
                            .padding()
                    }
                Spacer()
  
                NavigationLink(destination: ChooseGoalView (launchedByMainScreen: $showAddGoalsView), isActive: $showAddGoalsView) { EmptyView()}
            }
    
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

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}





