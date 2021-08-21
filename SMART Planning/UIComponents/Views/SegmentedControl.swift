//
//  SegmentedControl.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

struct SegmentedControl: View {
    
    @Binding var tab: PerformanceViewType
    @Namespace var animation
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: .weekly, animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
            TabButton(title: .monthly, animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
            TabButton(title: .total, animation: animation, currentTab: $tab)
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .padding(.horizontal, 2)
        .padding(3)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.horizontal)
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(tab: .constant(.weekly))
    }
}
