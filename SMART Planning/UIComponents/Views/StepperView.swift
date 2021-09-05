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
                .padding(.horizontal)
            }
        }
        
    }
}


struct GoalIndicator: View {
    @EnvironmentObject var viewModel: StepperViewModel
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
                
                Button {
                    withAnimation {
                        viewModel.isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(Color(itemColor))
                    
                }.offset(x: -itemSpacing.offset - 3, y: -5)
            }
        }
    }
    
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView(with: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}


final class StepperViewModel: ObservableObject {
    
    @Published var isExpanded = false
    var goalModel: GoalModel
    var subgoal: SubGoal?
    
    init(with model: GoalModel) {
        goalModel = model
        createSubgoal()
    }
    
    var daysPerStep: Double {
        goalModel.numberOfDays / Double(numberOfSteps - 1)
    }
    
    
    var numberOfSteps: Int {
        return min(7, max(Int(goalModel.numberOfDays / 30), 5))
    }
    
    
    var goalPerStep: Double {
        (goalModel.goal.desiredResult - goalModel.goal.baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var customSpacing: CGFloat {
        spacing.rawValue - 4
    }
    
    
    var dateText: [Date] {
        var localSteps = [Date]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = goalModel.goal.wrappedStartDate.adding(days: Int(time))
            localSteps.append(stepDate)
            time += daysPerStep
        }
        return localSteps
    }
    
    
    var goalText: [String] {
        var localSteps = [String]()
        var achievedResult = 0.0
        for _ in 0..<numberOfSteps {
            let decimalPoint = achievedResult > 100 ? 0 : 1
            let text = String(format: "%g", achievedResult.roundToDecimal(decimalPoint))
            localSteps.append(text)
            achievedResult += goalPerStep
        }
        return localSteps
    }
    
    
    var indicators: [Bool] {
        var localIndicators = [Bool]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = goalModel.goal.wrappedStartDate.adding(days: Int(time))
            let todayDate = Date()
            todayDate > stepDate ? localIndicators.append(true) : localIndicators.append(false)
            time += daysPerStep
        }
        
        return localIndicators
    }
    
    
    var spacing: Spacing {

        if numberOfSteps == 7 {
            return .sevenSteps
        } else if numberOfSteps == 6 {
            return .sixSteps
        } else {
            return .fiveSteps
        }
    }
    
    var expandAt: Int? {
        indicators.firstIndex(of: false)
    }
    
    
    func createSubgoal() {
        guard let index = expandAt else { return }
        
        
        let subgoal = SubGoal(baseProgress: Double(goalText[index - 1])!,
                              color: goalModel.goal.wrappedColor,
                              deadline: dateText[index],
                              desiredResult: Double(goalText[index])!,
                              startDate: dateText[index - 1],
                              unitsShort: goalModel.goal.wrappedUnitsShort)
        
        self.subgoal = subgoal
    }
}

struct SubGoal {
    var baseProgress: Double
    var color: String
    var deadline: Date
    var desiredResult: Double
    var startDate: Date
    var unitsShort: String
    
    var numberOfDays: TimeInterval {
        Double(deadline.days(from: startDate))
    }
    
    
    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }
    
    
    var numberOfSteps: Int {
        return min(5, max(Int(numberOfDays / 10), 3))
    }
    
    
    var goalPerStep: Double {
        (desiredResult - baseProgress) / Double(numberOfSteps - 1)
    }
    
    
    var customSpacing: CGFloat {
        spacing.rawValue - 4
    }
    
    
    var dateText: [Date] {
        var localSteps = [Date]()
        var time = 0.0
        for _ in 0..<numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
            localSteps.append(stepDate)
            time += daysPerStep
        }
        return localSteps
    }
    
    
    var goalText: [String] {
        var localSteps = [String]()
        var achievedResult = 0.0
        for _ in 0..<numberOfSteps {
            let decimalPoint = achievedResult > 10 ? 0 : 1
            let text = String(format: "%g", achievedResult.roundToDecimal(decimalPoint))
            localSteps.append(text)
            achievedResult += goalPerStep
        }
        
        return localSteps
    }
    
    
    var indicators: [Bool] {
        var localIndicators = [Bool]()
        var time = 0.0
        for _ in 1...numberOfSteps {
            let stepDate = startDate.adding(days: Int(time))
            let todayDate = Date()
            todayDate > stepDate ? localIndicators.append(true) : localIndicators.append(false)
            time += daysPerStep
        }
        
        return localIndicators
    }
    
    
    var spacing: Spacing {
        if numberOfSteps == 5 {
            return .fiveSteps
        } else if numberOfSteps == 4 {
            return .fourSteps
        } else {
            return .threeSteps
        }
    }
}
