//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

struct GoalLabel: View {
    
    var goalImage: String
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "\(goalImage).circle")
                .resizable()
                .scaledToFit()
                .frame(width: size / 5)
        }
    }
}

struct GoalLabel_Previews: PreviewProvider {
    static var previews: some View {
        GoalLabel(goalImage: "1", size: 375)
    }
}
