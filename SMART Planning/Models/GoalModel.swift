//
//  File.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI

struct GoalModel: Identifiable {
    var id = UUID()
    var goal: Goal
    var tasks = [Exercise]()
    
    init(_ goal: Goal) {
        self.goal = goal
        loadTasks()
    }
    
    var complementaryColor: String {
        goal.wrappedColor + "Complementary"
    }
    
    var totalNumberOfTasks: Int {
        let coef = Double(goal.wrappedDaysOfPractice) / 7.0
        let numberOfTasks = Int(numberOfDays * coef)
        return numberOfTasks
    }
    
    var dailyGoal: Double {
        let dailyGoal = (goal.desiredResult - goal.baseProgress) / numberOfDays
        let coef = 7.0 / Double(goal.wrappedDaysOfPractice)
        return coef * dailyGoal
    }
    
    var weeklyGoal: Double {
        dailyGoal * Double(goal.wrappedDaysOfPractice)
    }
    
    func createTasks() {
        var date = goal.wrappedStartDate
        let dailyAmountOfTraining = dailyGoal
        var currentProgress = goal.baseProgress
        for _ in 0..<Int(numberOfDays) {
            for day in goal.wrappedTrainingDays {
                if day == Calendar.current.component(.weekday, from: date) {
                    let task = Exercise(context: PersistenceManager.shared.viewContext)
                    task.taskID = UUID()
                    task.date = date
                    task.trainingAmount = dailyGoal
                    task.resultBeforeTraining = currentProgress
                    task.resultAfterTraining = currentProgress + dailyGoal
                    task.isCompleted = false
                    goal.addToTasks(task)
                    
                    currentProgress += dailyAmountOfTraining
                    break
                }
            }
            
            date = date.adding(days: 1)
            while !goal.wrappedTrainingDays.contains(Calendar.current.component(.weekday, from: date)) {
                date = date.adding(days: 1)
            }
        }
        
        PersistenceManager.shared.save()
    }
    
    mutating func loadTasks() {
        tasks = goal.wrappedTasks
        
        if tasks.isEmpty {
            createTasks()
            tasks = goal.wrappedTasks
        }
    }
    
    var todayTask: Double {
        tasks.filter { $0.wrappedDate.toString(.deadlineNextYear) == Date().toString(.deadlineNextYear)}.first?.trainingAmount ?? dailyGoal
    }
    
    var numberOfDays: TimeInterval {
        Double(goal.wrappedDeadline.days(from: goal.wrappedStartDate))
    }
}
    
    // MARK: -  Stepper View
extension GoalModel {
    
    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }
    
    var numberOfSteps: Int {
        return min(8, max(Int(numberOfDays / 30), 5))
    }
    
    var goalPerStep: Double {
        (goal.desiredResult - goal.baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var dateText: [Text] {
        var localSteps = [Text]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = goal.wrappedStartDate.adding(days: Int(time))
            let text = Text("\(stepDate.toString())")
            localSteps.append(text)
            time += daysPerStep
        }
        return localSteps
    }
    
    var goalText: [Text] {
        var localSteps = [Text]()
        var achievedResult = 0.0
        for _ in 0..<numberOfSteps {
            let decimalPoint = achievedResult > 100 ? 0 : 1
            let text = Text("\(String(format: "%g", achievedResult.roundToDecimal(decimalPoint))) \(goal.wrappedUnitsShort)")
            localSteps.append(text)
            achievedResult += goalPerStep
        }
        return localSteps
    }
    
    var indicators: [Bool] {
        var localIndicators = [Bool]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = goal.wrappedStartDate.adding(days: Int(time))
            let todayDate = Date()
            todayDate > stepDate ? localIndicators.append(true) : localIndicators.append(false)
            time += daysPerStep
        }
        
        return localIndicators
    }
    
    
    var spacing: Spacing {
        if numberOfSteps >= 8 {
            return .eightSteps
        } else if numberOfSteps == 7 {
            return .sevenSteps
        } else if numberOfSteps == 6 {
            return .sixSteps
        } else {
            return .fiveSteps
        }
    }
}

    // MARK: -  Performance View
extension GoalModel {
    
    func weeklyPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
        let sunday = Date().startOfWeek
        let week = (0...6).map { sunday.adding(days: $0).toString(.deadlineNextYear)}
        let thisWeekTasks = tasks.filter { week.contains($0.wrappedDate.toString(.deadlineNextYear))}
        
        let baseProgress = thisWeekTasks.min()?.resultBeforeTraining ?? 0
        let desiredProgress = thisWeekTasks.max()?.resultAfterTraining ?? 1
        let numberOfTasks = thisWeekTasks.count
        let numberOfCompletedTasks = thisWeekTasks.filter { $0.isCompleted }.count
        let thisWeekMileStone = thisWeekTasks.reduce(0) { $0 + $1.trainingAmount }.roundToDecimal(1)
        let currentProgress = thisWeekTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.trainingAmount }.roundToDecimal(1)
        
        completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisWeekMileStone, currentProgress)
    }
    
    
    func monthlyPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
        let datesOfMoths = Date().datesOfMoths(of: .deadlineNextYear)
        let thisMonthTasks = tasks.filter { datesOfMoths.contains($0.wrappedDate.toString(.deadlineNextYear))}
        
        let baseProgress = thisMonthTasks.min()?.resultBeforeTraining ?? 0
        let desiredProgress = thisMonthTasks.max()?.resultAfterTraining ?? 0
        let numberOfTasks = thisMonthTasks.count
        let numberOfCompletedTasks = thisMonthTasks.filter { $0.isCompleted }.count
        let thisMonthMileStone = thisMonthTasks.reduce(0) { $0 + $1.trainingAmount }
        let currentProgress = thisMonthTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.trainingAmount }
        
        completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisMonthMileStone, currentProgress)
    }
    
    
    func totalPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
        let numberOfTasks = tasks.count
        let numberOfCompletedTasks = tasks.filter { $0.isCompleted }.count
        
        completed(goal.baseProgress, goal.desiredResult, numberOfTasks, numberOfCompletedTasks, goal.desiredResult, goal.currentProgress)
    }
}
