//
//  SubGoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/5/21.
//

import SwiftUI

struct SubGoal {
    var baseProgress: Double
    var color: String
    var deadline: Date
    var desiredResult: Double
    var startDate: Date
    var unitsShort: String
    
    var numberOfDays: TimeInterval {
        Double(deadline.days(from: startDate))
    }
    
    
    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }
    
    
    var numberOfSteps: Int {
        return min(5, max(Int(numberOfDays / 10), 4))
    }
    
    
    var goalPerStep: Double {
        (desiredResult - baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var customSpacing: CGFloat {
        spacing.rawValue - 4
    }
    
    
    var dateText: [Date] {
        var localSteps = [Date]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
            localSteps.append(stepDate)
            time += daysPerStep
        }
        return localSteps
    }
    
    
    var goalText: [String] {
        var localSteps = [String]()
        var achievedResult = baseProgress
        for _ in 0..<numberOfSteps {
            let decimalPoint = achievedResult > 100 ? 0 : 1
            let text = String(format: "%g", achievedResult.roundToDecimal(decimalPoint))
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
            todayDate > stepDate ? localIndicators.append(true) : localIndicators.append(false)
            time += daysPerStep
        }
        
        return localIndicators
    }
    
    
    var spacing: Spacing {
        if numberOfSteps == 5 {
            return .fiveSteps
        } else {
            return .fourSteps
        }
    }
}
