//
//  GoalTargetCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import SwiftUI

struct GoalTargetCell: View {
    @EnvironmentObject var viewModel: GoalViewModel
    var size: CGSize
    
    var body: some View {
        HStack {
            Picker("", selection: $viewModel.selectedAction) {
                ForEach(viewModel.measurementActions, id:\.self) {
                    Text("\($0)")
                }
            }
            .frame(width: size.width / 3 - 30)
            .colorMultiply(Color(viewModel.selectedColor))
            .clipped()
            .onChange(of: viewModel.selectedAction) { _ in viewModel.isTargetEdited = true}
            
            TextField("Target", text: $viewModel.selectedMetric)
                .keyboardType(.numberPad)
                .overlay(textFieldBorder)
                .onChange(of: Int(viewModel.selectedMetric)) { _ in viewModel.convertSingularsAndPlurals() }
            
            Picker("", selection: $viewModel.selectedUnit) {
                ForEach(viewModel.measurementUnits, id:\.self) {
                    Text("\($0)")
                }
            }
            .frame(width: size.width / 3 - 30)
            .colorMultiply(Color(viewModel.selectedColor))
            .clipped()
            .onChange(of: viewModel.selectedUnit) { _ in viewModel.isTargetEdited = true}
            
        }
        .pickerStyle(WheelPickerStyle())
    }
    
    
    var textFieldBorder: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
        }
        .padding(.vertical, -5)
    }
}

struct GoalTargetCell_Previews: PreviewProvider {
    static var previews: some View {
        GoalTargetCell(size: UIScreen.main.bounds.size).environmentObject(GoalViewModel())
    }
}
