//
//  GoalDetailView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/17/21.
//

import SwiftUI

struct GoalDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var brain: GoalsManager
    @StateObject var viewModel: GoalDetailsViewModel
    @StateObject var editGoalViewModel = GoalViewModel()
    
    init(goal: GoalModel) {
        _viewModel = StateObject(wrappedValue: GoalDetailsViewModel(goal: goal))
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        TitleView(goal: viewModel.goal)
                        Divider()
                        NotificationsView(goal: viewModel.goal)
                        
                        CalendarView(goalModel: viewModel.goal)
                            .frame(width: geo.size.width, height: geo.size.width * 0.85)
                            .padding(.bottom)
                        
                        LazyVGrid(columns: viewModel.columns) {
                            ForEach(viewModel.stats) { statistic in
                                StatisticsView(image: statistic.image, color: statistic.color, metric: statistic.metrics, units: statistic.units)
                            }
                        }
                    }
                }
            }
            .alert(item: $viewModel.alertItem) { $0.alertWithSecondaryButton }
            .padding([.top, .leading, .trailing])
            .navigationBarTitle(viewModel.goal.goal.wrappedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismissView)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Delete")
                        .foregroundColor(.red)
                        .onTapGesture(perform: deletionAlert)
                    
                    
                }
            }
        }
        .environmentObject(editGoalViewModel)
        .accentColor(Color(viewModel.goal.color))
        
    }
    
    
    func dismissView() {
        dismiss()
    }
    
    
    func deletionAlert() {
        viewModel.alertItem = AlertContext.deleteConfirmation(action: deleteGoal)
    }
    
    
    func deleteGoal() {
        brain.goals.removeAll(where: {$0.goal.wrappedID == viewModel.goal.goal.wrappedID })
        NotificationManager.shared.cancelNotification(with: viewModel.goal.goal.wrappedID)
        PersistenceManager.shared.deleteGoal(viewModel.goal.goal)
        dismissView()
    }
}


struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailView(goal: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}


struct TitleView: View {
    @EnvironmentObject var editGoalViewModel: GoalViewModel
    var goal: GoalModel
    
    var body: some View {
        HStack(spacing: 15) {
            Image(goal.goal.wrappedIcon)
                .iconStyle(with: 45)
                .foregroundColor(Color(goal.color))
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(goal.goal.wrappedTitle)
                        .font(.title2.bold())
                    Image(Icons.pen.icon)
                        .iconStyle(with: 20)
                        .foregroundColor(Color(goal.color))
                        .onTapGesture(perform: showEditGoal)
                    NavigationLink(destination: GoalView(), isActive: $editGoalViewModel.isShowingGoalView) { EmptyView() }
                }
                
                Text(trainingDays)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    
    var trainingDays: String {
        goal.goal.wrappedTrainingDays.count == 7 ? "Everyday" : selectedDays
    }
    
    
    var selectedDays: String {
        goal.goal.wrappedTrainingDays.map { Calendar.current.shortWeekdaySymbols[$0 - 1] }.joined(separator: ", ")
    }
    
    
    func showEditGoal() {
        editGoalViewModel.setupEditingView(with: goal)
        editGoalViewModel.isShowingGoalView = true
    }
}


fileprivate struct NotificationsView: View {
    var goal: GoalModel
    
    var body: some View {
        HStack(spacing: 29) {
            Image(Icons.notification.icon)
                .iconStyle(with: 30)
                .foregroundColor(Color(goal.color))
                .offset(x: 8, y: 0)
            NavigationLink(destination: NotificationSettings(goal)) {
                HStack {
                    Text("Edit Notifications")
                        .font(.title3.bold())
                    Spacer()
                    Image(systemName: "chevron.right")
                        .iconStyle(with: 13)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                
            }.buttonStyle(PlainButtonStyle())
        }
    }
}


fileprivate struct StatisticsView: View {
    
    var image: String
    var color: String
    var metric: String
    var units: String
    
    var body: some View {
        VStack {
            Image(image)
                .iconStyle(with: 60)
                .foregroundColor(Color(color))
            
            Text(metric)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(units)
                .font(.headline)
                .foregroundColor(.secondary)
            
        }
        .padding(.bottom)
    }
}





