//
//  NotificationSettings.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/22/21.
//

import SwiftUI

struct NotificationSettings: View {
    
    @StateObject var viewModel: NotificationSettingsViewModel
    
    init(_ goal: GoalModel) {
        _viewModel = StateObject(wrappedValue: NotificationSettingsViewModel(goal: goal))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $viewModel.notificationIsOn.animation()) { Text("Notifications are \(viewModel.status)") }
            if viewModel.notificationIsOn {
                DatePicker("Select when you want to get notifications", selection: $viewModel.notificationTime, displayedComponents: .hourAndMinute)
                    .onChange(of: viewModel.notificationTime, perform: viewModel.setNotificationTime(_:))
            }
            Spacer()
        }
        .onDisappear(perform: PersistenceManager.shared.save)
        .padding()
        .navigationTitle("Notifications")
    }
}
