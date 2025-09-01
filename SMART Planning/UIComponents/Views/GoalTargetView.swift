//
//  GoalTargetCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import SwiftUI

struct GoalTargetView: View {
    @EnvironmentObject var viewModel: GoalViewModel
    @State var isExpanded = false
    @State var rotationDegrees = 0.0

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
            .onChange(of: viewModel.selectedAction) { _, _ in viewModel.isTargetEdited = true}
            
            TextField("Target", text: $viewModel.selectedMetric)
                .keyboardType(.numberPad)
                .overlay(textFieldBorder)
                .onChange(of: Int(viewModel.selectedMetric)) { _, _ in viewModel.convertSingularsAndPlurals() }
                .zIndex(1)
            Picker("", selection: $viewModel.selectedUnit) {
                ForEach(viewModel.measurementUnits, id:\.self) {
                    Text($0)
                }
            }
            .frame(width: size.width / 3 - 30)
            .colorMultiply(Color(viewModel.selectedColor))
            .clipped()
            .onChange(of: viewModel.selectedUnit) { _, _ in viewModel.isTargetEdited = true}
        }
        .pickerStyle(WheelPickerStyle())
        
        HStack {
            Text("Custom actions")
            Spacer()
            ChevronIcon()
                .foregroundColor(Color(viewModel.selectedColor))
                .rotationEffect(.degrees(rotationDegrees))
        }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation { isExpanded.toggle() } }
        .animation(.linear(duration: 0.3), value: isExpanded)
        .onChange(of: isExpanded) { _, _ in rotationDegrees += 180 }
        
        if isExpanded {
            HStack {
                CreateAlertButton(title: "Add Action", buttonAction: addActionPressed)

                CreateAlertButton(title: "Add Units", buttonAction: addUnitsPressed)
            }
        } 
    }
    
    func addActionPressed() {
        viewModel.showCustomActionAlert = true
    }
    
    func addUnitsPressed() {
        viewModel.showCustomUnitAlert = true
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
        GoalTargetView(size: UIScreen.main.bounds.size).environmentObject(GoalViewModel())
    }
}

struct ChevronIcon: View {
    
    var body: some View {
        Image(systemName: "chevron.down")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
    }
}

struct CreateAlertButton: View {
    @EnvironmentObject var viewModel: GoalViewModel
    var title: String
    var buttonAction: () -> Void
    
    
    var body: some View {
        Button(action:  buttonAction) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(Color(.white))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color(viewModel.selectedColor).cornerRadius(13))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
