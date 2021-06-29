//
//  File.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import Foundation
import StepperView


struct GoalModel: Identifiable {
    var id          = UUID()
    var name        : String
    var metric1     : Int
    var metric2     : Int?
    var startDate   : Date
    var deadline    : Date
    
    var goalTimeInSeconds: TimeInterval {
        let startNumber = startDate.timeIntervalSince1970
        let endNumber = deadline.timeIntervalSince1970
        let goalTimeInSeconds = endNumber - startNumber
        return goalTimeInSeconds
    }
    
    var stepAmount: Double {
        goalTimeInSeconds / Double(numberOfSteps)
    }
    
    var numberOfSteps: Int {
        goalTimeInSeconds / 4 < 864000 ? 4 : 6
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
        GoalModel(name: "Reading", metric1: 5, metric2: 200, startDate: Date().addingTimeInterval(-2592000), deadline: Date().addingTimeInterval(2592000)),
        GoalModel(name: "Gaining Weight", metric1: 68, metric2: 75, startDate: Date().addingTimeInterval(-459200), deadline: Date().addingTimeInterval(459200))]
}
