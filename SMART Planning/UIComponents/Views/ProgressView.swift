//
//  ProgressView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/9/21.
//

import SwiftUI

struct ProgressView: View {
    
    var numberOfSteps: Int
    var topText: [Text]
    var completionStage: [Bool]
    var bottomText: [Text]
    var itemSpacing: Spacing
    var itemColor: String
    
    var customSpacing: CGFloat {
        itemSpacing.rawValue - 4
    }
    
    var body: some View {
        HStack(alignment: .custom, spacing: customSpacing) {
            ForEach(0..<numberOfSteps, id:\.self) { step in
                GoalIndicator(topText: topText[step],
                           completionStage: completionStage[step],
                           bottomText: bottomText[step],
                           itemSpacing: itemSpacing,
                           drawSpacer: step != numberOfSteps - 1,
                           itemColor: itemColor)
            }
        }.offset(x: numberOfSteps == 4 ? -10 : 0)
    }
}


struct GoalIndicator: View {
    
    var topText: Text
    var completionStage: Bool
    var bottomText: Text
    var itemSpacing: Spacing
    var drawSpacer: Bool
    var itemColor: String
    
    var body: some View {
        VStack(alignment: .center) {
            topText
                .font(.caption2)
                .lineLimit(1)
                .fixedSize()
            
            ZStack {
                Image(systemName: completionStage ? "checkmark.circle.fill" : "record.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(completionStage ? Color(itemColor) : Color(.systemGray6))
                    .background(completionStage ? Color(.systemBackground) : Color(.systemGray3))
                    .clipShape(Circle())
                    .frame(width: min(30, itemSpacing.rawValue + 9))
                    .alignmentGuide(.custom) {$0[VerticalAlignment.center] }
                
                if drawSpacer {
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: itemSpacing.lineLength, height: 3)
                        .foregroundColor(completionStage ? Color(itemColor) : .secondary)
                        .alignmentGuide(.custom) {$0[VerticalAlignment.center] }
                        .offset(x: itemSpacing.offset)
                    
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 0, height: 0)
                        .foregroundColor(.white)
                }
            }
            
            bottomText
                .font(.caption2)
                .lineLimit(2)
                .frame(width: 35)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
        }
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(numberOfSteps: 7, topText: Array(repeating: Text("Sep, 7"), count: 7), completionStage: Array(repeating: true, count: 7), bottomText: Array(repeating: Text("3 kg"), count: 7), itemSpacing: .sevenSteps, itemColor: Colors.brandMagenta.rawValue)
    }
}
