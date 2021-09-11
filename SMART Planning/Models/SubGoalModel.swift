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
}

extension SubGoal: StepperData {
    
    
    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }
    
    
    var numberOfSteps: Int {
        return min(5, max(Int(numberOfDays / 10), 4))
    }
    
    
    var goalPerStep: Double {
        (desiredResult - baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var spacing: Spacing {
        if numberOfSteps == 5 {
            return .fiveSteps
        } else {
            return .fourSteps
        }
    }
}
