//
//  GoalViewCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/30/21.
//

import SwiftUI

struct GoalViewCell: View {
    
    var goalModel: GoalModel
    
    var body: some View {
        HStack {
            Image(goalModel.goal.wrappedIcon)
                .iconStyle(with: 30)
                .foregroundColor(Color(goalModel.goal.wrappedColor))

            Text(goalModel.goal.wrappedTitle)
                .font(.title3)
                .bold()
        }
        
        StepperView(numberOfSteps: goalModel.numberOfSteps, topText: goalModel.dateText, completionStage: goalModel.indicators, bottomText: goalModel.goalText, itemSpacing: goalModel.spacing, itemColor: goalModel.goal.wrappedColor)
            .padding(.bottom)
    }
}

struct GoalViewCell_Previews: PreviewProvider {
    static var previews: some View {
        GoalViewCell(goalModel: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}
