//
//  File.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI

struct Task: Identifiable {
    var id                  = UUID()
    var date                : Date
    var action              : String
    var trainingAmount      : Double
    var resultBeforeTraining: Double
    var resultAfterTraining : Double
    var units               : String
    var color               : String
    var icon                : String
    var isCompleted         = Bool.random()
}

extension Task: Comparable {
    static func < (lhs: Task, rhs: Task) -> Bool {
        lhs.date < rhs.date
    }
    
    
}


struct GoalModel: Identifiable {
    var id              = UUID()
    var name            : String
    var daily           = true
    var daysOfPractice  = 6
    var baseProgress    = 0.0
    var practiceAction  = "Read"
    var goalIcon        : String
    var goalColor       : String
    var desiredResult   : Double
    var measurableUnits = "Pages"
    var trainingDays    = [1, 2, 3, 4, 5, 7]
    var startDate       : Date
    var deadline        : Date
    
    
    var totalNumberOfTasks: Int {
        let coef = Double(daysOfPractice) / 7.0
        let numberOfTasks = Int(numberOfDays * coef)
        return numberOfTasks
        
    }
    
    var dailyGoal: Double {
        let dailyGoal = (desiredResult - baseProgress) / numberOfDays
        let coef = 7.0 / Double(daysOfPractice)
        return coef * dailyGoal
    }
    
    var weeklyGoal: Double {
        dailyGoal * Double(daysOfPractice)
    }
    
    var tasks: [Task] {
        var tasks = [Task]()
        var date = startDate
        var currentProgress = baseProgress
        for _ in 0..<totalNumberOfTasks {
            for day in trainingDays {
                if day == Calendar.current.component(.weekday, from: date) {
                    let task = Task(date: date, action: practiceAction, trainingAmount: dailyGoal, resultBeforeTraining: currentProgress, resultAfterTraining: currentProgress + dailyGoal, units: measurableUnits, color: goalColor, icon: goalIcon)
                    tasks.append(task)
                    currentProgress += dailyGoal
                    break
                }
            }
            //add check is new date is not one of the days used doesn't want to practice
            let newDate = date.adding(days: 1)
            date = newDate
        }
        return tasks
    }
    
    var numberOfDays: TimeInterval {
        Double(deadline.days(from: startDate))
    }
}

// MARK:  Stepper View
extension GoalModel {
    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }
    
    var numberOfSteps: Int {
        return min(8, max(Int(numberOfDays / 30), 4))
    }
    
    var goalPerStep: Double {
        (desiredResult - baseProgress) / Double(numberOfSteps - 1)
    }
    
    var steps: [StepperTextView] {
        var localSteps = [StepperTextView]()
        var time = 0.0
        var achievedResult = baseProgress
        for _ in 0..<numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
            let text = StepperTextView(text: "\(stepDate.toString())\n \(String(format: "%g", achievedResult.roundToDecimal(1)))")
            localSteps.append(text)
            
            time += daysPerStep
            achievedResult += goalPerStep
        }
        return localSteps
    }
    
    var dateText: [Text] {
        var localSteps = [Text]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
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
            let text = Text("\(String(format: "%g", achievedResult.roundToDecimal(1))) pa")
            localSteps.append(text)
            achievedResult += goalPerStep
        }
        return localSteps
    }
    
    var indicators: [Bool] {
        var localIndicators = [Bool]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
            let todayDate = Date()
            if todayDate > stepDate {
                localIndicators.append(true)
            } else {
                localIndicators.append(false)
            }
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
        } else if numberOfSteps == 5 {
            return .fiveSteps
        } else {
            return .fourSteps
        }
    }
    
    func weeklyPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
        let sunday = Date().startOfWeek
        let week = (0...6).map { sunday.adding(days: $0)}
        
        var thisWeekTasks: [Task] = []
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            for task in tasks {
                if let _ = week.firstIndex(where: { task.date.toString(.deadlineNextYear) == $0.toString(.deadlineNextYear)}) {
                    thisWeekTasks.append(task)
                }
                
                if thisWeekTasks.count == daysOfPractice {
                    break
                }
            }
//            if name == "Gaining Weight" {
//                print("😱😱😱 \(thisWeekTasks)")
//            }
            let baseProgress = thisWeekTasks.min()?.resultBeforeTraining ?? 213231.0
            let desiredProgress = thisWeekTasks.max()?.resultAfterTraining ?? 342433.3
            let numberOfTasks = thisWeekTasks.count
            let numberOfCompletedTasks = thisWeekTasks.filter { $0.isCompleted }.count
            let thisWeekMileStone = thisWeekTasks.reduce(0) { $0 + $1.trainingAmount }.roundToDecimal(1)
            let currentProgress = thisWeekTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.trainingAmount }.roundToDecimal(1)
            
//            if name == "Gaining Weight" {
//                print("😱😱😱 baseProgress \(baseProgress)")
//                print("😱😱😱 desiredProgress \(desiredProgress)")
//                print("😱😱😱 numberOfTasks \(numberOfTasks)")
//                print("😱😱😱 numberOfCompletedTasks \(numberOfCompletedTasks)")
//                print("😱😱😱 thisWeekMileStone \(thisWeekMileStone)")
//                print("😱😱😱 currentProgress \(currentProgress)")
//            }
    
            completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisWeekMileStone, currentProgress)
            
        }
    }
}


struct MocGoals {
    static let goals = [
        GoalModel(name: "Reading", goalIcon: Icons.banknote.rawValue, goalColor: Colors.brandBlue.rawValue, desiredResult: 1000, startDate: Date().adding(days: -35), deadline: Date().adding(days: 210)),
        GoalModel(name: "Gaining Weight", goalIcon: Icons.book.rawValue, goalColor: Colors.brandGrassGreen.rawValue, desiredResult: 7, startDate: Date().adding(days: -10), deadline: Date().adding(days: 10)),
        GoalModel(name: "Reading", goalIcon: Icons.briefcase.rawValue, goalColor: Colors.brandMagenta.rawValue, desiredResult: 1000, startDate: Date().adding(days: -35), deadline: Date().adding(days: 110)),
        GoalModel(name: "Reading", goalIcon: Icons.chat.rawValue, goalColor: Colors.brandOceanBlue.rawValue, desiredResult: 1000, startDate: Date().adding(days: -35), deadline: Date().adding(days: 140)),
        GoalModel(name: "Reading", goalIcon: Icons.currency.rawValue, goalColor: Colors.brandPink.rawValue, desiredResult: 1000, startDate: Date().adding(days: -35), deadline: Date().adding(days: 170)),
        GoalModel(name: "Reading", goalIcon: Icons.gym.rawValue, goalColor: Colors.brandTurquoise.rawValue, desiredResult: 1000, startDate: Date().adding(days: -35), deadline: Date().adding(days: 200)),
    ]
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
