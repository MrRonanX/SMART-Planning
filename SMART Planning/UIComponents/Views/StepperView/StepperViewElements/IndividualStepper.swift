//
//  IndividualStepper.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/11/21.
//

import SwiftUI

struct IndividualStepper: View {
    @EnvironmentObject var viewModel: StepperViewModel
    var stepperData: StepperData
        
    var expandAt: Int? {
        stepperData.shouldExpand ? stepperData.indicators.firstIndex(of: false) : nil
    }
    
    var body: some View {
        HStack(alignment: .custom, spacing: stepperData.customSpacing) {
            ForEach(0..<stepperData.numberOfSteps, id:\.self) { step in
                GoalIndicator(topText: stepperData.dateText[step].toString(),
                              completionStage: stepperData.indicators[step],
                              bottomText: stepperData.goalText[step],
                              itemSpacing: stepperData.spacing,
                              drawSpacer: step != stepperData.numberOfSteps - 1,
                              itemColor: stepperData.color,
                              shouldExpend: expandAt == step)
            }
        }
    }
}
