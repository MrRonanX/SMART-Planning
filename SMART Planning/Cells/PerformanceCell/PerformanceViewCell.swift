//
//  PerformanceViewCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

struct PerformanceViewCell: View {
    @ObservedObject var viewModel: PerformanceCellViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(viewModel.goal.goalIcon)
                        .iconStyle(with: 25)
                        .foregroundColor(Color(viewModel.goal.goalColor))
                    Text(viewModel.goal.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    Spacer()
                    
                    if viewModel.viewType == .total {
                        Text(viewModel.goalTimeRangeTitle).font(.headline)
                    }
                }
                
                HStack {
                    Image(systemName: viewModel.completedIcon)
                        .performanceIconStyle(with: viewModel.goal.goalColor)
                    Text(viewModel.completedText)
                    Spacer()
                }
                HStack {
                    Image(systemName: "flag")
                        .performanceIconStyle(with: viewModel.goal.goalColor)
                    Text(viewModel.milestoneText)
                    Spacer()
                }
                HStack {
                    Image(systemName: "text.badge.checkmark")
                        .performanceIconStyle(with: viewModel.goal.goalColor)
                    Text(viewModel.ongoingText)
                    Spacer()
                }
                
            }
            .padding(.top, 10)
            
            RectangleProgressView(viewModel: viewModel)
            ProgressLabels(viewModel: viewModel)
        }
        .padding([.horizontal, .bottom])
        .background(Color(viewModel.goal.complementaryColor))
//        .padding(.horizontal, 10)
        .cornerRadius(20)
        .animation(.easeOut(duration: 0.7))
    }
}

struct PerformanceViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceViewCell(viewModel: PerformanceCellViewModel(MocGoals.goals[1], viewType: .monthly))
    }
}
