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
        HStack(alignment: .top) {
            Image(goalModel.goal.wrappedIcon)
                .iconStyle(with: 35)
                .foregroundColor(Color(goalModel.goal.wrappedColor))
            VStack(alignment: .leading) {
                Text(goalModel.goal.wrappedTitle)
                    .font(.title3)
                    .bold()
                
                Text(goalModel.goal.wrappedGoalDescription)
                    .font(.subheadline)
            }
        }
    
        StepperView(with: goalModel)
            .padding(.bottom)
    }
}

struct GoalViewCell_Previews: PreviewProvider {
    static var previews: some View {
        GoalViewCell(goalModel: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}
