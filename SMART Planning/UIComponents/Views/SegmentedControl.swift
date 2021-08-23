//
//  SegmentedControl.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

enum SegmentedControlType: String, Identifiable {
    case weekly     = "Weekly"
    case monthly    = "Monthly"
    case total      = "Total"

    var type: String {
        self.rawValue
    }

    var id: String {
        UUID().uuidString
    }
}

struct SegmentedControl: View {
    
    @Binding var tab: SegmentedControlType
    @Namespace var animation
    var tabs: [SegmentedControlType]
    
    var body: some View {
        HStack(spacing: 0) {
                TabButton(title: tabs[0], animation: animation, currentTab: $tab)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                TabButton(title: tabs[1], animation: animation, currentTab: $tab)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                TabButton(title: tabs[2], animation: animation, currentTab: $tab)
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
        SegmentedControl(tab: .constant(.weekly), tabs: [.weekly, .monthly, .total])
    }
}



