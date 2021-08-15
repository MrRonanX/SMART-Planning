//
//  DailyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 7/6/21.
//

import SwiftUI

final class DailyTasksViewModel: ObservableObject {
    @Published var tasks : [Task] = []
    
    var todayTasks: [Task] {
        tasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    var weekTasks: [Task] {
        tasks.filter { $0.date > Date() }.filter { $0.date < Date().adding(days: 7) }
    }
    
    init () {
        for goal in MocGoals.goals {
            tasks.append(contentsOf: goal.tasks)
        }
        
        tasks.sort { $0.date < $1.date }
    }
    
    func taskCompleted(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            withAnimation {
                tasks[index].isCompleted.toggle()
            }
        }
    }
}


struct DailyTasksView: View {
    @StateObject var vm = DailyTasksViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(title: "Today")) {
                    ForEach(vm.todayTasks) { task in
                        GeometryReader { geo in
                            TaskCellView(task: task, size: geo.size)
                                .contentShape(Rectangle())
                                .onTapGesture { vm.taskCompleted(task: task) }
                        }
                    }
                }
                
                Section(header: SectionHeader(title: "Upcoming")) {
                    ForEach(vm.weekTasks) { task in
                        TaskCellView(task: task)
                    }
                }
            }
            .navigationTitle("Daily Tasks")
        }
    }
}


struct TaskCellView: View {
    
    let task: Task
    var size: CGSize?
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                .font(.headline)
                .imageScale(.large)
                .foregroundColor(task.isCompleted ? .green : .secondary)
                .padding(.horizontal, 5)
            
            Text("\(task.action)  \(Int(task.amount))  \(task.units)")
            
            Spacer()
            
            Image(task.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(task.color))
                .padding(.horizontal, 5)
            Text(task.date.toString(.list) == Date().toString(.list) ? "" : task.date.toString(.list))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(task.date.toString(.list) == Date().toString(.list) ? .green : .secondary)
        }
        .overlay(
            Color(.systemGray)
                .frame(height: task.isCompleted ? 1 : 0, alignment: .center)
        )
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
