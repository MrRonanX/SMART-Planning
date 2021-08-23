//
//  ChooseGoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

struct ChooseGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: ViewPresenter
    @StateObject var viewModel = GoalViewModel()
    
    @Binding var launchedByMainScreen: Bool
 
    var body: some View {
        NavigationView {
        GeometryReader { geo in
            body(for: geo.size.width)
            Spacer()
        }
        }.accentColor(Color(viewModel.selectedColor))
    }
    
    
    func body(for size: CGFloat) -> some View {
        VStack {
            Text("You may choose one from the list or create your own").font(.title3)
            Divider()
            LazyVGrid(columns: viewModel.columns) {
                ForEach(viewModel.goals) { goal in
                    GoalLabel(goal: goal, size: size)
                        .onTapGesture {
                            viewModel.showGoalView(goal: goal)
                        }
                }
            }
            NavigationLink(destination: GoalView(viewModel: viewModel), isActive: $viewModel.isShowingGoalView) { EmptyView() }
        }
        .padding()
        .navigationTitle("Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if launchedByMainScreen { Button("Done", action: dismissView) }
            }
        }
    }
    
    func dismissView() {
        launchedByMainScreen = false
    }
    
    
    func pushMainScreen() {
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

struct GoalCreationModel: Identifiable {
    var id = UUID()
    var title: String
    var action: String
    var image: String
    var unit: String
    var icon: String
    var illustration: String
    
    let randomColor = Colors.allCases.randomElement()?.color ?? "brandBlue"
    
    
    static let premadeGoals = [GoalCreationModel(title: "Reading", action: "Read", image: "book", unit: "pages", icon: "book", illustration: Illustrations.reading.image),
                               GoalCreationModel(title: "Getting Fit", action: "Train", image: "gym", unit: "times", icon: "gym", illustration: Illustrations.gettingFit.image),
                               GoalCreationModel(title: "Become Smarter", action: "Pass", image: "bookA", unit: "courses", icon: "bookA", illustration: Illustrations.becomeSmarter.image),
                               GoalCreationModel(title: "Gain Muscles", action: "Gain", image: "weightLift", unit: "kilograms", icon: "weightLift", illustration: Illustrations.gainMuscles.image),
                               GoalCreationModel(title: "Lose Weight", action: "Lose", image: "dumbbell", unit: "kilograms", icon: "dumbbell", illustration: Illustrations.loseWeight.image),
                               GoalCreationModel(title: "Learn A Language", action: "Learn", image: "chats", unit: "lessons", icon: "chats", illustration: Illustrations.learnLanguage.image),
                               GoalCreationModel(title: "Improve Your Art", action: "Paint", image: "paintBrush", unit: "pictures", icon: "paintBrush", illustration: Illustrations.improveArt.image),
                               GoalCreationModel(title: "Saving Money", action: "Save", image: "coins", unit: "dollars", icon: "coins", illustration: Illustrations.saveMoney.image),
                               GoalCreationModel(title: "Enlightenment", action: "Do", image: "idea", unit: "mediations", icon: "idea", illustration: Illustrations.enlightenment.image),
                               GoalCreationModel(title: "Learn A New Skill", action: "Complete", image: "graduationHat", unit: "courses", icon: "graduationHat", illustration: Illustrations.learnNewSkill.image),
                               GoalCreationModel(title: "Set You Goal", action: "", image: "award", unit: "", icon: "graduationHat", illustration: Illustrations.setYourGoal.image)]
}
