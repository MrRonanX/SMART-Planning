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
            IndividualStepper(stepperData: viewModel.goalModel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: viewModel.goalModel.numberOfSteps == 4 ? -10 : 0)
                .environmentObject(viewModel)
            if viewModel.isExpanded, let subgoal = viewModel.subgoal {
                IndividualStepper(stepperData: subgoal)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView(with: GoalModel(Goal(context: PersistenceManager.shared.viewContext)))
    }
}
