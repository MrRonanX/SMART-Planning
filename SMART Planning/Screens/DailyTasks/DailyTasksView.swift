//
//  DailyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 7/6/21.
//

import SwiftUI

final class DailyTasksViewModel: ObservableObject {
    @Published var id = UUID()
    @Published var todayTasks: [Exercise] = []
    @Published var weekTasks: [Exercise] = []
    @Published var tasks: [Exercise] = [] {
        willSet {
            todayTasks = newValue.filter { Calendar.current.isDateInToday($0.wrappedDate) }
            weekTasks = newValue.filter { $0.wrappedDate.midday() > Date().midday() }.filter { $0.wrappedDate < Date().adding(days: 7) }
        }
    }
    
    func taskCompleted(_ task: Exercise) {
        let amount = task.trainingAmount
        task.isCompleted.toggle()
        
        switch task.isCompleted {
        case true:
            task.goal?.currentProgress += amount
        case false:
            task.goal?.currentProgress -= amount
        }
        
        PersistenceManager.shared.save()
        id = UUID()
        
    }
    
    func loadTasks(from model: GoalsManager) {
        tasks = model.goals.flatMap { $0.tasks }.sorted { $0.wrappedDate < $1.wrappedDate }
    }
}


struct DailyTasksView: View {
    @EnvironmentObject var brain: GoalsManager
    @StateObject var vm = DailyTasksViewModel()
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(title: "Today")) {
                    ForEach(vm.todayTasks) { task in
                        GeometryReader { geo in
                            TaskCellView(task: task, size: geo.size)
                                .contentShape(Rectangle())
                                .onTapGesture { vm.taskCompleted(task) }
                        }
                    }
                }.id(vm.id)
                
                Section(header: SectionHeader(title: "Upcoming")) {
                    ForEach(vm.weekTasks) { task in
                        TaskCellView(task: task)
                    }
                }
            }
            .onAppear { vm.loadTasks(from: brain)}
            .navigationTitle("Daily Tasks")
        }
    }
}


struct TaskCellView: View {
    
    let task: Exercise
    var size: CGSize?
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                .font(.headline)
                .imageScale(.large)
                .foregroundColor(task.isCompleted ? .green : .secondary)
                .padding(.horizontal, 5)
            
            Text("\(task.action)  \(task.trainingAmount, specifier: "%0.2f")  \(task.units)")
                .foregroundColor(task.isCompleted ? .secondary : Color(.label))
                .font(task.isCompleted ? .body.italic() : .body)
            
            Spacer()
            
            Image(task.icon)
                .iconStyle(with: 25)
                .foregroundColor(Color(task.color))
                .padding(.horizontal, 5)
            Text(task.wrappedDate.toString(.list) == Date().toString(.list) ? "" : task.wrappedDate.toString(.list))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(task.wrappedDate.toString(.list) == Date().toString(.list) ? .green : .secondary)
        }
    }
}


struct SectionHeader: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.down")
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}


struct DailyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTasksView()
    }
}
