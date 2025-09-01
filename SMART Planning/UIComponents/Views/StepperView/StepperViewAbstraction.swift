//
//  StepperViewAbstraction.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/11/21.
//

import SwiftUI

protocol StepperData {
    var startDate: Date { get }
    var baseProgress: Double { get }
    var daysPerStep: Double { get }
    var numberOfSteps: Int { get }
    var goalPerStep: Double { get }
    var dateText: [Date] { get }
    var goalText: [String] { get }
    var indicators: [Bool] { get }
    var spacing: Spacing { get }
    var color: String { get }
    var shouldExpand: Bool { get }
}

extension StepperData {
    
    @MainActor
    var customSpacing: CGFloat {
        spacing.value - 4
    }
    
    var shouldExpand: Bool {
        false
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
}
