//
//  DailyTasksViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/28/21.
//

import Foundation

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
