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
    
    
    func createSubgoal() {
        guard let index = goalModel.indicators.firstIndex(of: false) else { return }
        
        let subgoal = SubGoal(baseProgress: Double(goalModel.goalText[index - 1])!,
                              color: goalModel.goal.wrappedColor,
                              deadline: goalModel.dateText[index],
                              desiredResult: Double(goalModel.goalText[index])!,
                              startDate: goalModel.dateText[index - 1],
                              unitsShort: goalModel.goal.wrappedUnitsShort)
        self.subgoal = subgoal
    }
}
