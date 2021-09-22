//
//  GoalDetailViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/17/21.
//

import SwiftUI

extension GoalDetailView {
    final class GoalDetailsViewModel: ObservableObject {
        @Published var stats: [Statistics] = []
        @Published var goal: GoalModel
        @Published var alertItem: AlertItem?
        
        var columns = Array(repeating: GridItem(.flexible()), count: 2)
        
        init(goal: GoalModel) {
            self.goal = goal
            createStatistic()
        }
        
        
        private func createStatistic() {
            let units       = goal.goal.wrappedUnits
            let progress    = goal.goal.currentProgress
            let result      = goal.goal.desiredResult
            let base        = goal.goal.baseProgress
            let startDate   = goal.goal.wrappedStartDate.toString(.deadlineNextYear)
            let deadline    = goal.goal.wrappedDeadline.toString(.deadlineNextYear)
            
            stats = [
                Statistics(image: GoalDetails.currentProgress, color: Colors.brandMagenta.color, metrics: "\(String(format: "%.2f", progress)) \(units)", units: "Current Progress"),
                Statistics(image: GoalDetails.desiredResult, color: Colors.brandSkyBlue.color, metrics: "\(String(format: "%2g", result)) \(units)", units: "Desired Result"),
                Statistics(image: GoalDetails.baseProgress, color: Colors.brandBlue.color, metrics: "\(String(format: "%2g", base)) \(units)", units: "Base Progress"),
                Statistics(image: GoalDetails.trainingPerDay, color: Colors.brandPurple.color, metrics: "\(String(format: "%.2f", goal.dailyGoal)) \(units)", units: "Training Per Day"),
                Statistics(image: GoalDetails.startDate, color: Colors.brandGrassGreen.color, metrics: startDate, units: "Start Date"),
                Statistics(image: GoalDetails.deadline, color: Colors.brandTurquoise.color, metrics: deadline, units: "Deadline")
            ]
        }
    }
}

struct Statistics: Identifiable {
    let id      = UUID()
    let image   : String
    let color   : String
    let metrics : String
    let units   : String
}
