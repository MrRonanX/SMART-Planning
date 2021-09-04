//
//  AlertItem.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/4/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    // MARK:  - Map View Errors
    
    static func notValid(_ metric: String) -> AlertItem {
        AlertItem(title: Text("\(metric.capitalized) Isn't Valid"),
                   message: Text("Please, make sure that \(metric) is set"),
                   dismissButton: .default(Text("OK")))
    }
}
