//
//  RectangleProgressView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/16/21.
//

import SwiftUI

struct RectangleProgressView: View {
    
    @ObservedObject var viewModel: PerformanceCellViewModel
    var completionCoef: CGFloat {
        max(CGFloat(viewModel.completionRate), 0.1)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Color(.systemGray4)
                    .cornerRadius(20)
                
                ZStack(alignment: .leading) {
                    Color(viewModel.goal.goalColor)
                        .frame(width: geo.size.width * completionCoef, alignment: .leading)
                        .cornerRadius(20)
                }
                
                Text("\(viewModel.completionRate * 100, specifier: "%.0f")% ")
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * completionCoef + 1, alignment: .trailing)
            }
        }
        .frame(height: 20)
    }
}


struct ProgressLabels: View {
    
    @ObservedObject var viewModel: PerformanceCellViewModel
    
    var textShouldHide: Bool {
        viewModel.completionRate < 0.1 || viewModel.completionRate > 0.9
    }
    
    var baseProgressShouldHide: Bool {
        viewModel.completionRate >= 0.1 && viewModel.completionRate <= 0.2
    }
    
    var completionRate: CGFloat {
        CGFloat(viewModel.completionRate)
    }
    
    var body: some View {
        HStack {
            GeometryReader { geo in
                Text("\(viewModel.originalProgress, specifier: "%.0f")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(baseProgressShouldHide ? 0: 1)
                Text("\(viewModel.currentProgressTitle, specifier: "%2g")")
                    .frame(width: geo.size.width * completionRate, alignment: .trailing)
                    .opacity(textShouldHide ? 0 : 1)
                Text("\(viewModel.finalProgress, specifier: "%.0f")")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}


struct RectangleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleProgressView(viewModel: PerformanceCellViewModel(MocGoals.goals[1], viewType: .monthly))
    }
}
