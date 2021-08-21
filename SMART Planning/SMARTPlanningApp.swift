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
//                IntroView()
//                    .environmentObject(settings)
//                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            } else {
                PlanningTabView().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            }
        }
    }
}

final class ViewPresenter: ObservableObject {
    @Published var goalIsSet = false
}


extension View {
    func correctDate(strDate: String) -> String {
        let date = strDate.toDate()!
        return date.toString()
    }
}
