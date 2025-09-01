//
//  PerformanceCellViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

@MainActor
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
        let localMilestone = goalMilestone == 0 ? 0.1 : goalMilestone
        let progress =  (currentProgress + 0.0001) / localMilestone
        return progress
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
        goal.weeklyPerformance { [weak self] baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.originalProgress = baseProgress
                self.finalProgress = desiredProgress
                self.numberOfCompletedTasks = completedTasks
                self.numberOfTasks = amountOfTasks
                self.goalMilestone = milestone
                self.currentProgress = progress
            }
        }
    }
    
    
    func setMonthlyData() {
        goal.monthlyPerformance { [weak self] baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.originalProgress = baseProgress
                self.finalProgress = desiredProgress
                self.numberOfCompletedTasks = completedTasks
                self.numberOfTasks = amountOfTasks
                self.goalMilestone = milestone
                self.currentProgress = progress
            }
        }
    }
    
    
    func setTotalData() {
        goal.totalPerformance { [weak self] baseProgress, desiredProgress, amountOfTasks, completedTasks, milestone, progress in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.originalProgress = baseProgress
                self.finalProgress = desiredProgress
                self.numberOfCompletedTasks = completedTasks
                self.numberOfTasks = amountOfTasks
                self.goalMilestone = milestone
                self.currentProgress = progress
            }
        }
    }
}
