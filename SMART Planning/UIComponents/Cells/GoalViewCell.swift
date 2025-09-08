//
//  GoalViewCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/30/21.
//

import SwiftUI

struct GoalViewCell: View {
    var goalModel: GoalModel
    var size: CGFloat

    var body: some View {
        HStack(alignment: .top) {
            Image(goalModel.goal.icon)
                .iconStyle(with: 35)
                .foregroundColor(Color(goalModel.goal.color))
            VStack(alignment: .leading) {
                Text(goalModel.goal.title)
                    .font(.title3)
                    .bold()
                
                Text(goalModel.goal.goalDescription)
                    .font(.subheadline)
            }
        } .padding(.horizontal, 10)
       
        StepperView(with: goalModel.goal, size: size)
            .padding(.bottom, 5)
    }
}

//struct GoalViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalViewCell(goalModel: GoalModel(Goal()), size: 375)
//    }
//}
