//
//  DailyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 7/6/21.
//

import SwiftUI

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
            
            Text("\(task.action.capitalized)  \(trainingAmount, specifier: "%2g")  \(task.units)")
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
    
    var trainingAmount: Double {
        task.trainingAmount > 2 ? ceil(task.trainingAmount) : task.trainingAmount.roundToDecimal(2)
    }
}


struct SectionHeader: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.down")
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}


struct DailyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTasksView()
    }
}
