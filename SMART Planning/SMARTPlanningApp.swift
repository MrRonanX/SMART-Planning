//
//  SMART_PlanningApp.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

@main
struct SMARTPlanningApp: App {
    
    @StateObject var settings = ViewPresenter()
    var body: some Scene {
        WindowGroup {
//            if !settings.goalIsSet {
            ChooseGoalView(launchedByMainScreen: .constant(false))
                    .environmentObject(settings)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            } else {
//                PlanningTabView().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            }
        }
    }
}

final class ViewPresenter: ObservableObject {
    @Published var goalIsSet = false
    @Published var isShowingIntro = true
}


extension View {
    func correctDate(strDate: String) -> String {
        let date = strDate.toDate()!
        return date.toString()
    }
}
