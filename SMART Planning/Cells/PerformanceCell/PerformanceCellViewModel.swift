//
//  PerformanceCellViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

final class PerformanceCellViewModel: ObservableObject {
    @Published var goal: GoalModel
    
    @Published var goalMilestone = 0.01
    @Published var currentProgress = 0.0001
    @Published var originalProgress = 0.0
    @Published var finalProgress = 1.0
    @Published var numberOfCompletedTasks = Int()
    @Published var numberOfTasks = Int()
    @Published var viewType: SegmentedControlType = .weekly {
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
       withAnimation { (currentProgress + 0.0001) / goalMilestone }
    }
    
    
    var currentProgressTitle: Double {
        (currentProgress + originalProgress).roundToDecimal(2)
    }
    
    
    var completedIcon: String {
        numberOfCompletedTasks == numberOfTasks ? "checkmark.seal.fill" : "checkmark.square"
    }
    
    
    var completedText: String {
        let plurality = numberOfTasks == 1 ? "task" : "tasks"
        return "Completed \(numberOfCompletedTasks) / \(numberOfTasks) \(plurality)"
    }
    
    
    var milestoneText: LocalizedStringKey {
        "Milestone \(goalMilestone.roundToDecimal(2), specifier: "%2g") \(goal.goal.wrappedUnits.lowercased())"
    }
    
    
    var ongoingText: LocalizedStringKey {
        "Ongoing \(goalMilestone.roundToDecimal(2) - currentProgress.roundToDecimal(2), specifier: "%2g") \(goal.goal.wrappedUnits.lowercased())"
    }
    
    
    var goalTimeRangeTitle: String {
        let firstDay = goal.goal.wrappedStartDate.toString(.stepper)
        let lastDay = goal.goal.wrappedDeadline.toString(.stepper)
        
        return firstDay + " – " + lastDay
    }
    
    
    init(_ goal: GoalModel, viewType: SegmentedControlType) {
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
                currentProgress = progress
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
                currentProgress = progress
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
                currentProgress = progress
            }
        }
    }
}

