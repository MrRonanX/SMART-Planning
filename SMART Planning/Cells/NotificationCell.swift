//
//  NotificationCell.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/22/21.
//

import SwiftUI

enum NotificationSegmentType: String, Identifiable {
    case morning    = "Morning"
    case afternoon  = "Afternoon"
    case evening    = "Evening"
    case dontNotify = "Don't Notify"
    
    var id: UUID {
        UUID()
    }
    
    var title: String {
        switch self {
        case .morning, .afternoon, .evening:
            return "Notify in the " + self.rawValue.lowercased()
        case .dontNotify:
            return self.rawValue
        }
    }
    
    var hour: Int {
        switch self {
        case .morning:
            return 9
        case .afternoon:
            return 14
        case .evening:
            return 20
        case .dontNotify:
            print("Notification Error")
            return 0
        }
    }
}

struct NotificationCell: View {
    @EnvironmentObject var viewModel: GoalViewModel
    @State var isExpanded = false
    @State var rotationDegrees = 0.0
    @Namespace var cellAnimation
    var buttons: [NotificationSegmentType] = [.morning, .afternoon, .evening]
    
    var body: some View {
        HStack {
            Text(viewModel.notificationTime.title)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(viewModel.selectedColor))
                .frame(width: 15, height: 15)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation { isExpanded.toggle() } }
        .animation(.linear(duration: 0.3))
        .onChange(of: isExpanded, perform: { _ in rotationDegrees += 180 })
        
        if isExpanded {
            VStack {
                HStack {
                    ForEach(buttons) { button in
                        ButtonForNotification(title: button)
                            .onTapGesture { selectNotificationTime(time: button) }
                    }
                }
                
                ButtonForNotification(title: .dontNotify)
                    .onTapGesture { selectNotificationTime(time: .dontNotify) }
            }
            .onChange(of: viewModel.notificationTime) { _ in viewModel.requestAuthorization() }
        }
    }
    
    func selectNotificationTime(time: NotificationSegmentType) {
        withAnimation {  viewModel.notificationTime = time }
    }
}

struct ButtonForNotification: View {
    @EnvironmentObject var viewModel: GoalViewModel
    var title: NotificationSegmentType
    
    var body: some View {
        Text(title.rawValue)
            .fontWeight(.medium)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(backgroundColor.cornerRadius(13))
    }
    
    var backgroundColor: some View {
        viewModel.notificationTime == title ? Color(viewModel.selectedColor) : Color(.formTabButtonColor)
    }
    
    var textColor: Color {
        viewModel.notificationTime == title ? Color(.white) : Color(.label)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell().environmentObject(GoalViewModel())
    }
}
