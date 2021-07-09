//
//  WeeklyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI



struct WeeklyPerformance: View {
    
    @State var goals = MocGoals.goals
    var colors: [Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(0..<goals.count) { num in
                        TaskView(task: goals[num], color: colors[num])
                            .padding([.horizontal, .bottom])
                    }.padding(.top)
                }
            }.navigationTitle("Weekly Performance")
        }
    }
}

struct WeeklyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyPerformance()
    }
}
#warning("Add metrics to measure weekly goals")
struct TaskView: View {
    
    var task: GoalModel
    var color: Color
    var body: some View {
        HStack {
            Image(systemName: "circlebadge.fill")
                .foregroundColor(color)
            Text(task.name)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text("\(task.weeklyGoal, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.semibold)
        }.onAppear {
            print(task)
        }
    }
}
