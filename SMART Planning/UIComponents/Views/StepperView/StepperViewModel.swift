//
//  StepperViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/5/21.
//

import SwiftUI

final class StepperViewModel: ObservableObject {
    
    @Published var isExpanded = false
    var goalModel: GoalModel
    var subgoal: SubGoal?
    
    init(with model: GoalModel) {
        goalModel = model
        createSubgoal()
    }
    
    var daysPerStep: Double {
        goalModel.numberOfDays / Double(numberOfSteps - 1)
    }
    
    
    var numberOfSteps: Int {
        return min(7, max(Int(goalModel.numberOfDays / 30), 5))
    }
    
    
    var goalPerStep: Double {
        (goalModel.goal.desiredResult - goalModel.goal.baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var customSpacing: CGFloat {
        spacing.rawValue - 4
    }
    
    
    var dateText: [Date] {
        var localSteps = [Date]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = goalModel.goal.wrappedStartDate.adding(days: Int(time))
            localSteps.append(stepDate)
            time += daysPerStep
        }
        return localSteps
    }
    
    
    var goalText: [String] {
        var localSteps = [String]()
        var achievedResult = goalModel.goal.baseProgress
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
        for _ in 0..<numberOfSteps {
            let stepDate = goalModel.goal.wrappedStartDate.adding(days: Int(time))
            let todayDate = Date()
            todayDate > stepDate ? localIndicators.append(true) : localIndicators.append(false)
            time += daysPerStep
        }
        
        return localIndicators
    }
    
    
    var spacing: Spacing {

        if numberOfSteps == 7 {
            return .sevenSteps
        } else if numberOfSteps == 6 {
            return .sixSteps
        } else {
            return .fiveSteps
        }
    }
    
    
    var expandAt: Int? {
        indicators.firstIndex(of: false)
    }
    
    
    func createSubgoal() {
        guard let index = expandAt else { return }
        
        
        let subgoal = SubGoal(baseProgress: Double(goalText[index - 1])!,
                              color: goalModel.goal.wrappedColor,
                              deadline: dateText[index],
                              desiredResult: Double(goalText[index])!,
                              startDate: dateText[index - 1],
                              unitsShort: goalModel.goal.wrappedUnitsShort)
        self.subgoal = subgoal
    }
}
