//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

struct GoalLabel: View {
    
    var goal: GoalCreationModel
    var size: CGSize
    
    var body: some View {
        VStack {
            Image(goal.illustration)
                .resizable()
                .scaledToFit()
                .frame(width: size.width / 4.2)
                .clipShape(Circle())
            
            Text(goal.title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .frame(width: size.width / 4.5)

        }
        
    }
    
    var strokeColor: Color {
        Color.black.opacity(0.1)
    }
}

struct GoalLabel_Previews: PreviewProvider {
    static var previews: some View {
        GoalLabel(goal: GoalCreationModel(title: "Learn A New Skill", action: "Learn", image: "graduationHat", unit: "courses", icon: "graduationHat", illustration: Illustrations.learningNewSkill.image), size: CGSize(width: 814, height: 390))
    }
}
