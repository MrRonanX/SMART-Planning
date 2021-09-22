//
//  AlertItem.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/4/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: primaryButton)
    }
    
    var alertWithSecondaryButton: Alert {
        Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton!)
    }
    
    let id = UUID()
    let title: Text
    let message: Text
    let primaryButton: Alert.Button
    var secondaryButton: Alert.Button? = nil
}

struct AlertContext {
    
    // MARK:  - Map View Errors
    
    static func notValid(_ metric: String) -> AlertItem {
        AlertItem(title: Text("\(metric.capitalized) Isn't Valid"),
                   message: Text("Please, make sure that \(metric) is set"),
                   primaryButton: .default(Text("OK")))
    }
    
    static func deleteConfirmation(action: @escaping () -> Void) -> AlertItem {
        AlertItem(title: Text("Delete Goal"),
                   message: Text("This action is irreversible."),
                   primaryButton: .cancel(Text("Back")),
                   secondaryButton: .destructive(Text("Delete"), action: action))
        
        
    }
}
