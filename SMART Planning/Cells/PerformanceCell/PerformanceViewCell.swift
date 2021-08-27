//
//  PerformanceViewCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

struct PerformanceViewCell: View {
    @ObservedObject var viewModel: PerformanceCellViewModel
    var goalColor: String {
        viewModel.goal.goal.wrappedColor
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(viewModel.goal.goal.wrappedIcon)
                        .iconStyle(with: 25)
                        .foregroundColor(Color(goalColor))
                    Text(viewModel.goal.goal.wrappedTitle)
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
                        .performanceIconStyle(with: goalColor)
                    Text(viewModel.completedText)
                    Spacer()
                }
                HStack {
                    Image(systemName: "flag")
                        .performanceIconStyle(with: goalColor)
                    Text(viewModel.milestoneText)
                    Spacer()
                }
                HStack {
                    Image(systemName: "text.badge.checkmark")
                        .performanceIconStyle(with: goalColor)
                    Text(viewModel.ongoingText)
                    Spacer()
                }
                
            }
            .padding(.top, 10)
            
            RectangleProgressView(viewModel: viewModel)
                .animation(.easeOut(duration: 0.7))
            ProgressLabels(viewModel: viewModel)
                .animation(.easeOut(duration: 0.7))
        }
        .padding([.horizontal, .bottom])
        .background(Color(viewModel.goal.complementaryColor))
        .cornerRadius(20)
        
    }
}

struct PerformanceViewCell_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceViewCell(viewModel: PerformanceCellViewModel(GoalModel(Goal(context: PersistenceManager.shared.viewContext)), viewType: .monthly))
    }
}
