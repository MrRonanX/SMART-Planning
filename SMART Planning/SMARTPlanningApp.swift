//
//  SMART_PlanningApp.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

@main
struct SMARTPlanningApp: App {
    var body: some Scene {
        WindowGroup {
            TimelineView()
        }
    }
}

extension View {
    func correctDate(strDate: String) -> String {
        let date = strDate.toDate()!
        return date.toString()
    }
}
