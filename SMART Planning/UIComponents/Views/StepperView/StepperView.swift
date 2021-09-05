//
//  ProgressView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/9/21.
//

import SwiftUI

struct StepperView: View {
    
    @StateObject var viewModel: StepperViewModel
    
    init(with goalModel: GoalModel) {
        _viewModel = StateObject(wrappedValue: StepperViewModel(with: goalModel))
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .custom, spacing: viewModel.customSpacing) {
                ForEach(0..<viewModel.numberOfSteps, id:\.self) { step in
                    GoalIndicator(topText: viewModel.dateText[step].toString(),
                                  completionStage: viewModel.indicators[step],
                                  bottomText: viewModel.goalText[step],
                                  itemSpacing: viewModel.spacing,
                                  drawSpacer: step != viewModel.numberOfSteps - 1,
                                  itemColor: viewModel.goalModel.goal.wrappedColor,
                                  shouldExpend: viewModel.expandAt == step)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(x: viewModel.numberOfSteps == 4 ? -10 : 0)
            .environmentObject(viewModel)
            
            if viewModel.isExpanded, let subgoal = viewModel.subgoal {
                
                HStack(alignment: .custom, spacing: subgoal.customSpacing) {
                    ForEach(0..<subgoal.numberOfSteps, id:\.self) { step in
                        GoalIndicator(topText: subgoal.dateText[step].toString(),
                                      completionStage: subgoal.indicators[step],
                                      bottomText: subgoal.goalText[step],
                                      itemSpacing: subgoal.spacing,
                                      drawSpacer: step != subgoal.numberOfSteps - 1,
                                      itemColor: viewModel.goalModel.goal.wrappedColor,
                                      shouldExpend: false)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        
    }
}


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
                    .frame(width: min(30, itemSpacing.rawValue + 9))
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


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView(with: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}
