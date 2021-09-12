//
//  GoalIndicator.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/11/21.
//

import SwiftUI

struct GoalIndicator: View {
    @EnvironmentObject var viewModel: StepperViewModel
    @State var rotationDegrees = 0.0
    var topText: String
    var completionStage: Bool
    var bottomText: String
    var itemSpacing: Spacing
    var drawSpacer: Bool
    var itemColor: String
    var shouldExpend: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text(topText)
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
                    .frame(width: itemSpacing.pictureSize)
                    .alignmentGuide(.custom) {$0[VerticalAlignment.center] }
                    .frame(width: itemSpacing.lineLength)
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
            
            Text(bottomText)
                .font(.caption2)
                .lineLimit(2)
                .frame(width: 35)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
            
            if shouldExpend {
                
                Button(action: toggleExpansion) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(Color(itemColor))
                        .rotationEffect(.degrees(rotationDegrees))
                }
                .offset(x: -itemSpacing.offset - 3, y: -5)
            }
        }
    }
    
    
    func toggleExpansion() {
        withAnimation {
            viewModel.isExpanded.toggle()
            rotationDegrees += 180
        }
    }
}

