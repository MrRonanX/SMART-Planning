//
//  ChooseGoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/27/21.
//

import SwiftUI

struct ChooseGoalView: View {
    @EnvironmentObject var settings: ViewSelector
    
    @StateObject var viewModel = GoalViewModel()
    
    @Binding var launchedByMainScreen: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                body(for: geo.size)
            }
        }
        .environmentObject(viewModel)
        .accentColor(Color(viewModel.selectedColor))
    }
    
    
    func body(for size: CGSize) -> some View {
        VStack {
            Text("You may choose one from the list or create your own").font(.title3)
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(viewModel.goals) { goal in
                        GoalLabel(goal: goal, size: size)
                            .onTapGesture { viewModel.showGoalView(for: goal) }
                    }
                }.padding(.top, 5)
            }

            NavigationLink(destination: GoalView(), isActive: $viewModel.isShowingGoalView) { EmptyView() }
                .onChange(of: viewModel.isShowingGoalView) { _ in pushMainScreen() }
        }
        .padding([.top, .leading, .trailing])
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
        if !launchedByMainScreen && viewModel.isShowingGoalView == false && viewModel.goalIsSet {
            settings.firstGoalIsSet()
            
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
    
    
    static let premadeGoals = [GoalCreationModel(title: "Reading", action: "Read", image: "book", unit: "pages", icon: "book", illustration: Illustrations.reading),
                               GoalCreationModel(title: "Getting Fit", action: "Train", image: "gym", unit: "times", icon: "gym", illustration: Illustrations.gettingFit),
                               GoalCreationModel(title: "Becoming Smarter", action: "Pass", image: "bookA", unit: "courses", icon: "bookA", illustration: Illustrations.becomingSmarter),
                               GoalCreationModel(title: "Building Muscles", action: "Gain", image: "weightLift", unit: "kilograms", icon: "weightLift", illustration: Illustrations.buildingMuscles),
                               GoalCreationModel(title: "Losing Weight", action: "Lose", image: "dumbbell", unit: "kilograms", icon: "dumbbell", illustration: Illustrations.losingWeight),
                               GoalCreationModel(title: "Learning Language", action: "Learn", image: "chats", unit: "lessons", icon: "chats", illustration: Illustrations.learningLanguage),
                               GoalCreationModel(title: "Improve Your Art", action: "Paint", image: "paintBrush", unit: "pictures", icon: "paintBrush", illustration: Illustrations.improveArt),
                               GoalCreationModel(title: "Saving Money", action: "Save", image: "coins", unit: "dollars", icon: "coins", illustration: Illustrations.savingMoney),
                               GoalCreationModel(title: "Enlightenment", action: "Do", image: "idea", unit: "mediations", icon: "idea", illustration: Illustrations.enlightenment),
                               GoalCreationModel(title: "Learning New Skill", action: "Complete", image: "graduationHat", unit: "courses", icon: "graduationHat", illustration: Illustrations.learningNewSkill),
                               GoalCreationModel(title: "Create Your Goal", action: "", image: "award", unit: "", icon: "graduationHat", illustration: Illustrations.createGoal)]
}
