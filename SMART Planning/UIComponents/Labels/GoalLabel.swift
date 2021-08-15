//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

struct GoalLabel: View {
    
    var goal: GoalCreationModel
    var size: CGFloat
    
    var body: some View {
        VStack {
            Image(goal.image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size / 7)
                .foregroundColor(Color(goal.randomColor))
                .clipShape(Circle())
            
            Text(goal.title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
        }
    }
}

struct GoalLabel_Previews: PreviewProvider {
    static var previews: some View {
        GoalLabel(goal: GoalCreationModel(title: "Learn A New Skill", action: "Learn", image: "graduationHat", unit: "courses", icon: "graduationHat"), size: 375)
    }
}
