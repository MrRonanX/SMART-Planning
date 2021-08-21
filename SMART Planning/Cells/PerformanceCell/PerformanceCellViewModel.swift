//
//  PerformanceCellViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

final class PerformanceCellViewModel: ObservableObject {
    @Published var goal: GoalModel
    
    @Published var goalMilestone = 1.0
    @Published var currentProgress = 0.1
    @Published var originalProgress = 0.0
    @Published var finalProgress = 1.0
    @Published var numberOfCompletedTasks = 1
    @Published var numberOfTasks = 0
    @Published var viewType: PerformanceViewType = .weekly {
        didSet {
            switch viewType {
            case .weekly:
                setWeeklyData()
                
            case .monthly:
                setMonthlyData()
                
            case .total:
                setTotalData()
            }
        }
    }
    
    var completionRate: Double {
        withAnimation { currentProgress / goalMilestone }
    }
    
    var currentProgressTitle: Double {
        (currentProgress + originalProgress).roundToDecimal(1)
    }
    
    
    var completedIcon: String {
        numberOfCompletedTasks == numberOfTasks ? "checkmark.seal.fill" : "checkmark.square"
    }
    
    
    var completedText: String {
        let plurality = numberOfTasks == 1 ? "task" : "tasks"
        return "Completed \(numberOfCompletedTasks) / \(numberOfTasks) \(plurality)"
    }
    
    var milestoneText: LocalizedStringKey {
        "Milestone \(goalMilestone, specifier: "%2g") \(goal.measurableUnits.lowercased())"
    }
    
    var ongoingText: LocalizedStringKey {
        "Ongoing \(goalMilestone - currentProgress, specifier: "%2g") \(goal.measurableUnits.lowercased())"
    }
    
    
    var goalTimeRangeTitle: String {
        let firstDay = goal.startDate.toString(.stepper)
        let lastDay = goal.deadline.toString(.stepper)
        
        return firstDay + " – " + lastDay
    }
    
    
    init(_ goal: GoalModel, viewType: PerformanceViewType) {
        self.goal = goal
        self.viewType = viewType
    }
    
    
    func setWeeklyData() {
        goal.weeklyPerformance { baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            DispatchQueue.main.async { [self] in
                
                originalProgress = baseProgress
                finalProgress = desiredProgress
                numberOfCompletedTasks = completedTasks
                numberOfTasks = amountOfTasks
                goalMilestone = milestone
                currentProgress = progress.roundToDecimal(1)
            }
        }
    }
    
    
    func setMonthlyData() {
        goal.monthlyPerformance {  baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            DispatchQueue.main.async { [self] in
                
                originalProgress = baseProgress
                finalProgress = desiredProgress
                numberOfCompletedTasks = completedTasks
                numberOfTasks = amountOfTasks
                goalMilestone = milestone
                currentProgress = progress.roundToDecimal(1)
            }
        
        }
    }
    
    
    func setTotalData() {
        goal.totalPerformance {  baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            DispatchQueue.main.async { [self] in
                
                originalProgress = baseProgress
                finalProgress = desiredProgress
                numberOfCompletedTasks = completedTasks
                numberOfTasks = amountOfTasks
                goalMilestone = milestone
                currentProgress = progress.roundToDecimal(1)
            }
        
        }
    }
}

