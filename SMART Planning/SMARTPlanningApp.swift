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
                ChooseGoalView(launchedByMainScreen: .constant(false))
                    .environmentObject(viewSelector)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .overlay(IntroView(hasSeenIntro: viewSelector.hasSeenIntro))
                    .onChange(of: viewSelector.hasSeenIntro) { _ in viewSelector.introDismissed()}
            } else {
                PlanningTabView().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
        }
    }
}

final class ViewSelector: ObservableObject {
    
    @Published var goalIsSet    : Bool
    @Published var hasSeenIntro : Bool
    
    init() {
        goalIsSet = UserDefaults.standard.bool(forKey: "goalIsSet")
        hasSeenIntro = UserDefaults.standard.bool(forKey: "hasSeenIntro")
    }
    
    
    func introDismissed() {
        UserDefaults.standard.set(true, forKey: "hasSeenIntro")
    }
    
    
    func firstGoalIsSet() {
        UserDefaults.standard.set(true, forKey: "goalIsSet")
    }
}
