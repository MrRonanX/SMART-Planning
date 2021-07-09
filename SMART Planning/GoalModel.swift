//
//  File.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import Foundation
import StepperView

struct Task: Identifiable {
    var id = UUID()
    var date: Date
    var action: String
    var amount: Double
    var units: String
    
}


struct GoalModel: Identifiable {
    var id              = UUID()
    var name            : String
    var daily           = true
    var daysOfPractice  = 7
    var desiredResult   : Int
    var mesurableUnits  = "Pages"
    var trainingDays    : DateComponents = []
    var startDate       : Date
    var deadline        : Date
    
    
    var totalNumberOfTasks: Int {
        let totalTimeInDays = goalTimeInSeconds / 86_400
        let coef = Double(daysOfPractice) / Double(7)
        let numberOfTasks = Int(totalTimeInDays * coef)
        return numberOfTasks
        
    }
    
    var dailyGoal: Double {
        let totalTimeInDays = goalTimeInSeconds / 86_400
        let dailyGoal = Double(desiredResult) / totalTimeInDays
        let coef = 7 / daysOfPractice
        return Double(coef) * dailyGoal
    }
    
    var weeklyGoal: Double {
        dailyGoal * Double(daysOfPractice)
    }
    
    var tasks: [Task] {
        var tasks = [Task]()
        var date = startDate
        for _ in 0..<totalNumberOfTasks {
            let task = Task(date: date, action: name, amount: dailyGoal, units: mesurableUnits)
            tasks.append(task)
            
            //add check is new date is not one of the days used doesn't want to practice
            let newDate = Date(timeIntervalSince1970: (date.timeIntervalSince1970 + 86_400))
            date = newDate
        }
        return tasks
    }
    
    var goalTimeInSeconds: TimeInterval {
        let startNumber = startDate.timeIntervalSince1970
        let endNumber = deadline.timeIntervalSince1970
        let goalTimeInSeconds = endNumber - startNumber
        return goalTimeInSeconds
    }
    

}

// MARK:  Stepper View
extension GoalModel {
    var stepAmount: Double {
        goalTimeInSeconds / Double(numberOfSteps)
    }
    
    var numberOfSteps: Int {
        goalTimeInSeconds / 4 < 864_000 ? 4 : 6
    }
    
    var steps: [StepperTextView] {
        var localSteps = [StepperTextView]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = startDate.addingTimeInterval(time)
            let text = StepperTextView(text: stepDate.toString())
            localSteps.append(text)
            time += stepAmount
        }
        return localSteps
    }
    
    var indicators: [StepperIndicationType<StepperImageView>] {
        var localIndicators = [StepperIndicationType<StepperImageView>]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = startDate.addingTimeInterval(time).timeIntervalSince1970
            let todayDate = Date().timeIntervalSince1970
            if todayDate > stepDate {
                localIndicators.append(StepperIndicationType.custom(StepperImageView(name: "completed")))
            } else {
                localIndicators.append(StepperIndicationType.custom(StepperImageView(name: "pending")))
            }
            time += stepAmount
        }
        return localIndicators
    }
    
    var lifeCycles: [StepLifeCycle] {
        var localLifeCycles = [StepLifeCycle]()
        var time = 0.0
        
        for _ in 1...numberOfSteps {
            let stepDate = startDate.addingTimeInterval(time).timeIntervalSince1970
            let todayDate = Date().timeIntervalSince1970
            
            todayDate > stepDate ? localLifeCycles.append(.completed) : localLifeCycles.append(.pending)
            time += stepAmount
        }
        return localLifeCycles
    }
    
    var spacing: CGFloat {
        numberOfSteps == 4 ? 30 : 23
    }
}

struct MocGoals {
    static let goals = [
        GoalModel(name: "Reading", desiredResult: 1000, startDate: Date().addingTimeInterval(-2_592_000), deadline: Date().addingTimeInterval(2_592_000)),
        GoalModel(name: "Gaining Weight", desiredResult: 7, startDate: Date().addingTimeInterval(-459_200), deadline: Date().addingTimeInterval(459_200))]
}
