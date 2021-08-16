//
//  WeeklyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

final class PerformanceViewModel: ObservableObject {
    
    @Published var goals = MocGoals.goals
    @Published var currentTab = "Weekly"
    
    var weekRangeTitle: String {
        let sunday = Date().startOfWeek
        let saturday = sunday.adding(days: 6)
        
        return sunday.toString(.deadline) + "-" + saturday.toString(.deadline)
    }
    

}


struct PerformanceView: View {
    
    @StateObject var viewModel = PerformanceViewModel()
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(tab: $viewModel.currentTab)
                HStack {
                    Text(viewModel.weekRangeTitle)
                        .font(.title3)
                        .padding()
                    Spacer()
                }

                Divider().padding(.bottom)
                
                ScrollView {
                    ForEach(viewModel.goals) { goal in
                        let cellViewModel = PerformanceCellViewModel(goal)
                        PerformanceViewCell(viewModel: cellViewModel)
                    }
                }
            }
            .navigationTitle("Progress")
        }.environmentObject(viewModel)
    }
}


struct WeeklyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}

struct PerformanceViewCell: View {
    @ObservedObject var viewModel: PerformanceCellViewModel
    @State var dataLoaded = false
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circlebadge.fill")
                    .foregroundColor(Color(viewModel.goal.goalColor))
                Text(viewModel.goal.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.goalMilestone, specifier: "%2g")")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            RectangleProgressView(viewModel: viewModel)
            ProgressLabels(viewModel: viewModel)
        }
        .padding([.horizontal, .bottom])
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        if !dataLoaded {
            viewModel.setTitles()
            dataLoaded = true
        }
    }
}



    final class PerformanceCellViewModel: ObservableObject {
        @Published var goal: GoalModel
        
        @Published var goalMilestone = 1.0
        @Published var currentProgress = 0.1
        @Published var originalProgress = 0.0
        @Published var finalProgress = 1.0
        @Published var numberOfCompletedTasks = 0
        @Published var numberOfTasks = 0
        
        var completionRate: Double {
            withAnimation { currentProgress / goalMilestone }
        }
        
        var currentProgressTitle: Double {
            (currentProgress + originalProgress).roundToDecimal(1)
        }
        
        init(_ goal: GoalModel) {
            self.goal = goal
        }
        
        func setTitles() {
            goal.weeklyPerformance { baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
                DispatchQueue.main.async { [self] in
                    
                    originalProgress = baseProgress
                    finalProgress = desiredProgress
                    numberOfCompletedTasks = completedTasks
                    numberOfTasks = amountOfTasks
                    goalMilestone = milestone
                    currentProgress = progress.roundToDecimal(1)
                }
            }
        }
    }


struct SegmentedControl: View {
    
    @Binding var tab: String
    @Namespace var animation

    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Weekly", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
            TabButton(title: "Monthly", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
            TabButton(title: "Total", animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .padding(.horizontal, 4)
        .padding(3)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
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
                .padding(.vertical, 4)
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
