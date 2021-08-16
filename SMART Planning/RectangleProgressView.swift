//
//  RectangleProgressView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/16/21.
//

import SwiftUI

struct ProgressLabels: View {
    
    @ObservedObject var viewModel: PerformanceCellViewModel
    var textShouldHide: Bool {
        viewModel.completionRate < 0.1 || viewModel.completionRate > 0.9 ? true : false
    }
    
    var baselineShouldHide: Bool {
        viewModel.completionRate >= 0.1 && viewModel.currentProgress <= 0.2 ? true : false
    }
    
    var completionRate: CGFloat {
        CGFloat(viewModel.completionRate)
    }
    
    var body: some View {
        
        HStack {
            GeometryReader { geo in
                Text("\(viewModel.originalProgress, specifier: "%.0f")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(viewModel.currentProgressTitle, specifier: "%2g")")
                    .frame(width: geo.size.width * completionRate, alignment: .trailing)
                    .opacity(textShouldHide ? 0 : 1)
                    .animation(.linear)
                Text("\(viewModel.finalProgress, specifier: "%.0f")")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .opacity(baselineShouldHide ? 0: 1)
            }
        }
        .padding(.horizontal)
        
        }
}

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
                        .animation(.linear)
                }
                
                Text("\(completionCoef * 100, specifier: "%.0f")% ")
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * completionCoef + 1, alignment: .trailing)
                    .animation(.linear)
            }
        }
        .frame(height: 20)
        .padding(.horizontal)
    }
}

struct RectangleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleProgressView(viewModel: PerformanceCellViewModel(MocGoals.goals[1]))
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
