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
            .fullScreenCover(item: $detailView) { model in GoalDetailView(goal: model)}
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
    
    var trainingDays: String {
        if goal.goal.wrappedTrainingDays.count == 7 {
            return "Everyday"
        } else {
            return goal.goal.wrappedTrainingDays.map { Calendar.current.shortWeekdaySymbols[$0 - 1] }.joined(separator: ", ")
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
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
                        Divider()
                        HStack(spacing: 29) {
                            Image(Icons.dumbbell.icon) // TODO: - Change icon
                                .iconStyle(with: 30)
                                .foregroundColor(Color(goal.color))
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
                        
                        CalendarView(goalModel: goal)
                            .frame(width: geo.size.width, height: geo.size.width * 0.85)
                        
                        
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                            StatisticsView(image: Icons.start.icon, color: Colors.brandMagenta.color, metric: "\(String(format: "%.2f", goal.goal.currentProgress)) \(goal.goal.wrappedUnits)", units: "Current Progress")
                            StatisticsView(image: Icons.award.icon, color: Colors.brandSkyBlue.color, metric: "\(String(format: "%2g", goal.goal.desiredResult)) \(goal.goal.wrappedUnits)", units: "Desired Result")
                            StatisticsView(image: Icons.mobile.icon, color: Colors.brandBlue.color, metric: "\(String(format: "%2g", goal.goal.baseProgress)) \(goal.goal.wrappedUnits)", units: "Base Progress")
                            StatisticsView(image: Icons.gym.icon, color: Colors.brandPurple.color, metric: "\(String(format: "%.2f", goal.dailyGoal)) \(goal.goal.wrappedUnits)", units: "Training Per Day")
                            StatisticsView(image: Icons.book.icon, color: Colors.brandGrassGreen.color, metric: goal.goal.wrappedStartDate.toString(.deadlineNextYear), units: "Start Date")
                            StatisticsView(image: Icons.desktop.icon, color: Colors.brandTurquoise.color, metric: goal.goal.wrappedDeadline.toString(.deadlineNextYear), units: "Deadline")
                        }
                        .padding(.top)
                        
                        
                        
                        Text("Delete")
                            .foregroundColor(.red)
                        
                    }
                    
                }
                
            }
            .padding([.top, .leading, .trailing])
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


struct StatisticsView: View {
    
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
