//
//  GoalDetailView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/17/21.
//

import SwiftUI

struct GoalDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var brain: GoalsManager
    @StateObject var viewModel: GoalDetailsViewModel
    
    init(goal: GoalModel) {
        _viewModel = StateObject(wrappedValue: GoalDetailsViewModel(goal: goal))
    }
    
    var body: some View {
        NavigationView {
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
            .padding([.top, .leading, .trailing])
            .navigationBarTitle(viewModel.goal.goal.wrappedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismissView)
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


fileprivate struct TitleView: View {
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
}


fileprivate struct NotificationsView: View {
    var goal: GoalModel
    
    var body: some View {
        HStack(spacing: 29) {
            Image(Icons.notification.icon)
                .iconStyle(with: 30)
                .foregroundColor(Color(goal.color))
                .offset(x: 8, y: 0)
            NavigationLink(destination: Text("Edit Notifications")) {
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

