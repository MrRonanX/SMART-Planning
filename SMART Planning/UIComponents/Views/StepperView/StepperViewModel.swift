//
//  StepperViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/5/21.
//

import SwiftUI

final class StepperViewModel: ObservableObject {
    
    @Published var isExpanded = false
    var data: StepperData
    var subgoal: SubGoal?
    
    init(with goal: Goal) {
        data = StepperInfo(goal: goal)
        createSubgoal()
    }
    
    
    func createSubgoal() {
        guard let index = data.indicators.firstIndex(of: false) else { return }

        let subgoal = SubGoal(
            baseProgress: Double(data.goalText[index - 1])!,
            color: data.color,
            deadline: data.dateText[index],
            desiredResult: Double(data.goalText[index])!,
            startDate: data.dateText[index - 1],
            displayUnits: data.displayUnits
        )
        self.subgoal = subgoal
    }
}

struct StepperInfo: StepperData {

    var startDate: Date
    var baseProgress: Double
    var daysPerStep: Double
    var numberOfSteps: Int
    var goalPerStep: Double
    var spacing: Spacing
    var color: GoalColor
    var displayUnits: String

    init(goal: Goal) {
        let numberOfDays = Double(goal.deadline.days(from: goal.startDate))
        startDate = goal.startDate
        baseProgress = goal.baseProgress
        numberOfSteps = min(7, max(Int(numberOfDays / 30), 5))
        daysPerStep = numberOfDays / Double(numberOfSteps - 1)
        goalPerStep = (goal.desiredResult - goal.baseProgress) / Double(numberOfSteps - 1)
        color = goal.color
        displayUnits = goal.unitsShort
        spacing =
        if numberOfSteps == 7 {
            .sevenSteps
        } else if numberOfSteps == 6 {
            .sixSteps
        } else {
            .fiveSteps
        }
    }
}

