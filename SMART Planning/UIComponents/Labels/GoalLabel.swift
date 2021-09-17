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
        VStack(spacing: 5) {
            Image(goal.illustration)
                .resizable()
                .scaledToFit()
                .frame(width: size.width / 4.5)
                .padding(.top, 5)
            
            Text(goal.title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .frame(width: size.width / 4.5)
            
            Spacer()
        }
        .frame(width: size.width / 3.7)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(.shadowBackground))
                .shadow(color: strokeColor, radius: 3, x: 1, y: 1)
        )
        .padding([.bottom, .horizontal], 10)
        
        
    }
    
    var strokeColor: Color {
        Color.black.opacity(0.1)
    }
}

struct GoalLabel_Previews: PreviewProvider {
    static var previews: some View {
        GoalLabel(goal: GoalCreationModel(title: "Learn A New Skill", action: "Learn", image: "graduationHat", unit: "courses", icon: "graduationHat", illustration: Illustrations.learningNewSkill), size: CGSize(width: 814, height: 390))
    }
}
