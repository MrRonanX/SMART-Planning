//
//  ChooseGoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

// Goals:
// Get Fit
// Become smarter
// Learn a Language
// Painting
// Saving money
// Meditating
// Studding
// Exercising
// Learning a new skill



struct ChooseGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: ViewPresenter
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    #warning("Create view model")
    
    @State private var isShowingGoalView = false
    @State private var goToMainView = false
    @Binding var launchedByMainScreen: Bool
    
    //set a goal here
    @State private var goal = 0
    
    var body: some View {
        GeometryReader { geo in
            body(for: geo.size.width)
        }
        
    }
    
    func body(for size: CGFloat) -> some View {
        VStack {
            Text("You may choose one from the list or create your own")
                .font(.title2)
            Divider()
            LazyVGrid(columns: columns) {
                ForEach(0..<8) { goal in
                    GoalLabel(goalImage: "\(goal)", size: size)
                        .onTapGesture {
                            showGoalView(goal: goal)
                        }
                }
                GoalLabel(goalImage: "plus", size: size)
                    .onTapGesture {
                        showGoalView(goal: goal)
                    }
            }
            Spacer()
            
        }
        .sheet(isPresented: $isShowingGoalView, onDismiss: pushMainScreen) { GoalView() }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Goals")
        
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if launchedByMainScreen {
                    Button("Done") {
                        launchedByMainScreen = false
                    }
                }
            }
        }
    }
    
    func showGoalView(goal: Int) {
        self.goal = goal
        isShowingGoalView = true
    }
    
    func pushMainScreen() {
        #warning("save goal")
        
        if !launchedByMainScreen {
            settings.goalIsSet = true
        }
    }
}

struct ChooseGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGoalView(launchedByMainScreen: .constant(false))
    }
}
