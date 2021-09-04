//
//  SMART_PlanningApp.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

@main
struct SMARTPlanningApp: App {
    
    @StateObject var viewSelector = ViewSelector()
    
    var body: some Scene {
        WindowGroup {
            if !viewSelector.goalIsSet {
                IntroOrGoalView()
                    .environmentObject(viewSelector)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            } else {
                PlanningTabView().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
        }
    }
}

final class ViewSelector: ObservableObject {
    
    @Published var goalIsSet    : Bool
    
    init() {
        goalIsSet = UserDefaults.standard.bool(forKey: "goalIsSet")
    }
    
    
    func firstGoalIsSet() {
        UserDefaults.standard.set(true, forKey: "goalIsSet")
        goalIsSet = true
    }
}
