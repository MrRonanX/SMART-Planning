//
//  WeeklyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/30/21.
//

import SwiftUI

struct PerformanceView: View {
    @EnvironmentObject var brain: GoalsManager
    @StateObject var viewModel = PerformanceViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                SegmentedControl(tab: $viewModel.currentTab, tabs: [.weekly, .monthly, .total])
                if viewModel.currentTab != .total {
                HStack {
                    Text(viewModel.performanceRangeTitle)
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    Spacer()
                }
                }
                ForEach(viewModel.goals) { goal in
                    let cellViewModel = PerformanceCellViewModel(goal, viewType: viewModel.currentTab)
                    PerformanceViewCell(viewModel: cellViewModel)
                }
            }
            .navigationTitle("Progress")
        }
        .onAppear { viewModel.loadGoals(from: brain)}
        .environmentObject(viewModel)
    }
}


struct WeeklyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}
