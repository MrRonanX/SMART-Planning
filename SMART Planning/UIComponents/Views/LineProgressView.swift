//
//  LineProgressView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/16/21.
//

import SwiftUI

struct LineProgressView: View {
    
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
                    Color(viewModel.goal.goal.wrappedColor)
                        .frame(width: geo.size.width * completionCoef, alignment: .leading)
                        .cornerRadius(20)
                }
                
                Text("\(viewModel.completionRate * 100, specifier: "%.0f")% ")
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * completionCoef + 1, alignment: .trailing)
                    .offset(x: -1, y: -1)
            }
        }
        .frame(height: 20)
    }
}


struct ProgressLabels: View {
    
    @ObservedObject var viewModel: PerformanceCellViewModel
    
    var body: some View {
        HStack {
            GeometryReader { geo in
                Text("\(viewModel.originalProgress, specifier: "%.0f")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(baseProgressShouldHide ? 0: 1)
                Text("\(viewModel.currentProgressTitle, specifier: "%2g")")
                    .frame(width: geo.size.width * completionRate, alignment: .trailing)
                    .opacity(textShouldHide ? 0 : 1)
                Text(finalProgress)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    var textShouldHide: Bool {
        viewModel.completionRate < 0.1 || viewModel.completionRate > 0.9
    }
    
    
    var baseProgressShouldHide: Bool {
        viewModel.completionRate >= 0.1 && viewModel.completionRate <= 0.2
    }
    
    
    var completionRate: CGFloat {
        CGFloat(viewModel.completionRate)
    }
    
    
    var finalProgress: LocalizedStringKey {
        "\(viewModel.finalProgress.roundToDecimal(2), specifier: "%2g")"
    }
}


struct RectangleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LineProgressView(viewModel: PerformanceCellViewModel(GoalModel(Goal(context: PersistenceManager.shared.viewContext)), viewType: .monthly))
    }
}
