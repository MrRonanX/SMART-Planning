//
//  ExpandableCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import SwiftUI

struct DaySelectionCell: View {
    @EnvironmentObject var viewModel: GoalViewModel
    @State var isExpanded = false
    @State var rotationDegrees = 0.0
    
    var title: String {
        let selectedCount = viewModel.days.filter { $0.isSelected }.count
        return selectedCount == 7 ? "Everyday" : viewModel.days.filter { $0.isSelected }.map { $0.longTitle}.joined(separator: ", ")
    }
    
    var body: some View {
        HStack {
            Text(title).font(.title3)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 15, height: 15)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation { isExpanded.toggle() } }
        .animation(.linear(duration: 0.3))
        .onChange(of: isExpanded, perform: { _ in rotationDegrees += 180 })
        
        if isExpanded {
            HStack {
                Spacer()
                ForEach(viewModel.days) { item in
                    DayCircle(day: item)
                        .onTapGesture { toggleDaySelection(for: item) }
                }
                Spacer()
            }.padding(.vertical, 7)
        }
    }
    
    
    func toggleDaySelection(for day: DayCircleModel) {
        guard let index = viewModel.days.firstIndex(where: { $0.id.uuidString == day.id.uuidString }) else { return }
        viewModel.days[index].isSelected.toggle()
    }
}


struct DayCircle: View {
    
    @EnvironmentObject var viewModel: GoalViewModel
    var day: DayCircleModel
    
    var body: some View {
        Circle()
            .frame(width: 35, height: 35)
            .foregroundColor(day.isSelected ? Color(viewModel.selectedColor) : .secondary)
            .overlay(
                Text(day.title)
                    .font(.headline)
                    .foregroundColor(.white)
            )
    }
}

struct ExpandableCell_Previews: PreviewProvider {
    static var previews: some View {
        DaySelectionCell().environmentObject(GoalViewModel())
    }
}
