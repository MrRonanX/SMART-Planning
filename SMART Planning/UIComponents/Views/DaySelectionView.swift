//
//  ExpandableCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import SwiftUI

struct DaySelectionView: View {

    @EnvironmentObject var viewModel: GoalViewModel
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(viewModel.days) { item in
                DayChip(day: item)
                    .onTapGesture { toggleDaySelection(for: item) }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    
    func toggleDaySelection(for day: DayChipModel) {
        guard let index = viewModel.days.firstIndex(where: { $0.id.uuidString == day.id.uuidString }) else { return }
        viewModel.days[index].isSelected.toggle()
    }
}


fileprivate struct DayChip: View {

    @EnvironmentObject var viewModel: GoalViewModel
    var day: DayChipModel

    var body: some View {
        Text(day.title)
            .foregroundStyle(Color.primary)      
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(day.isSelected ? viewModel.complimentaryColor : Color.clear)
            .cornerRadius(8)
    }
}

struct ExpandableCell_Previews: PreviewProvider {
    static var previews: some View {
        DaySelectionView().environmentObject(GoalViewModel())
    }
}
