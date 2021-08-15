//
//  WeeklyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

final class PerformanceViewModel: ObservableObject {
    
    @Published var goals = MocGoals.goals
    
}


struct PerformanceView: View {
    
    @State var goals = MocGoals.goals
    @State var currentTab = "Weekly"
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(tab: $currentTab)

                ScrollView {
                    ForEach(goals) { goal in
                        TaskView(task: goal)
                            .padding([.horizontal, .bottom])
                    }.padding(.top)
                }
            }.navigationTitle("Weekly Performance")
        }
    }
}


struct WeeklyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}
#warning("Add metrics to measure weekly goals")
struct TaskView: View {
    
    var task: GoalModel
    
    var body: some View {
        HStack {
            Image(systemName: "circlebadge.fill")
                .foregroundColor(Color(task.goalColor))
            Text(task.name)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text("\(task.weeklyGoal, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}

struct SegmentedControl: View {
    
    @Binding var tab: String
    @Namespace var animation

    var body: some View {
        HStack(spacing: 20) {
            TabButton(title: "Weekly", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.2), radius: 4)
            TabButton(title: "Monthly", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.2), radius: 4)
            TabButton(title: "Total", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.2), radius: 4)
        }
        .padding(3)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

struct TabButton: View {
    
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    
    var body: some View {
        
        Button(action: buttonAction) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(whiteBackground)
        }
    }
    
    
    var whiteBackground: some View {
        ZStack {
            if currentTab == title {
                    Color(.tertiarySystemBackground)
                    .cornerRadius(12)
                    .matchedGeometryEffect(id: "TAB", in: animation)
            }
        }
    }
    
    
    func buttonAction() {
        withAnimation {
            currentTab = title
        }
    }
}
