//
//  TabButton.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

struct TabButton: View {
    
    var title: PerformanceViewType
    var animation: Namespace.ID
    @Binding var currentTab: PerformanceViewType
    
    var body: some View {
        
        Button(action: buttonAction) {
            Text(title.type)
                .fontWeight(.medium)
                .foregroundColor(Color(.label))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(whiteBackground)
        }
    }
    
    
    var whiteBackground: some View {
        ZStack {
            if currentTab == title {
                Color(.tabButtonColor)
                    .cornerRadius(8)
                    .matchedGeometryEffect(id: "TAB", in: animation)
            }
        }
    }
    
    
    func buttonAction() {
        withAnimation {
            currentTab = title
        }
    }
}

struct TabButton_Previews: PreviewProvider {
    @Namespace static var animation
    static var previews: some View {
        TabButton(title: .total, animation: animation, currentTab: .constant(.total))
    }
}
