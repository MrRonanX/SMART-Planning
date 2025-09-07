//
//  GoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
// //


import SymbolPicker
import SwiftUI

struct GoalView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settings: ViewSelector
    @StateObject var viewModel: GoalViewModel
    @State private var isShowingIcons = false

    init(goal: GoalCreationModel) {
        _viewModel = StateObject(wrappedValue: GoalViewModel(goal: goal))
    }

    init(goal: Goal) {
        _viewModel = StateObject(wrappedValue: GoalViewModel(goal: goal))
    }

    var body: some View {
        Form {
            Section {
                TextField("Your Goal", text:  $viewModel.goalTitle, onCommit: dismissKeyboard)
                TextEditor(text: $viewModel.description)
                    .frame(height: 100, alignment: .top)
                    .foregroundColor(.primary)
                    .onAppear(perform: viewModel.addObservers)
            }
            Section("Personalization") {
                HStack {
                    FormButton(buttonType: .icons, tapAction: showIcons)
                    Divider()
                    FormButton(buttonType: .colors)
                }
            }

            Section(header: Text("Frequency")) {
                DaySelectionView()
                HStack(spacing: .zero) {
                    Text("Repeat")
                    Spacer()
                    Menu {
                        ForEach(viewModel.repeatMenuSelection, id:\.self) { selection in
                            Button(selection) { viewModel.setRepeatSelection(selection)}
                        }
                    } label: {
                        Text(viewModel.repeatSelection)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(viewModel.complimentaryColor)
                            .cornerRadius(8)
                    }
                }
            }

            Section("Deadline & Notifications") {
                DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                    .datePickerStyle(ColoredCompactPickerStyle(color: viewModel.complimentaryColor))

                HStack {
                    Text(viewModel.deadlineTitle)
                    Spacer()
                    DeadlineMenu()
                }

                DatePicker("Deadline", selection: $viewModel.deadlineDate, in: viewModel.dateRange, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(Color(viewModel.complimentaryColor))

                NotificationSelection()
            }
        }
        .environmentObject(viewModel)
        .alert(item: $viewModel.alertItem) { $0.alert }
        .textFieldAlert(isPresented: $viewModel.showCustomActionAlert, onDismiss: viewModel.actionAlertDismissed) {
            TextFieldAlert(title: "Enter Custom Action", message: nil, text: $viewModel.selectedAction, placeholder: "e.i. Create")
        }
        .textFieldAlert(isPresented: $viewModel.showCustomUnitAlert, onDismiss: viewModel.unitAlertDismissed) {
            TextFieldAlert(title: "Enter Custom Units", message: nil, text: $viewModel.selectedUnit, placeholder: "e.i. Days")
        }
        .sheet(isPresented: $isShowingIcons) {
            SymbolPicker(symbol: $viewModel.selectedIcon)
                .tint(viewModel.complimentaryColor)
                .foregroundStyle(viewModel.selectedColor)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(viewModel.goalTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: save) { Text("Save") }
            }
        }
    }

    func save() {
        viewModel.saveToCoreData()
        settings.firstGoalIsSet()
        dismiss()
    }

    func showIcons() {
        isShowingIcons = true
    }
}


fileprivate struct FormWithoutHeader<Content: View>: View {
    
    @State var isLoaded = false
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        UITableView.appearance().tableHeaderView = view
        UITableView.appearance().showsVerticalScrollIndicator = false
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    var body: some View {
        Form {
            if isLoaded {
                content
            } else {
                Text("Dummy").onAppear { isLoaded = true }
            }
        }
    }
}


fileprivate struct DeadlineMenu: View {
    @EnvironmentObject var viewModel: GoalViewModel
    
    var body: some View {
        Menu {
            ForEach(viewModel.goalShortcut, id:\.self) { days in
                Button(days == 365 ? "1 Year" : "\(days) Days") { viewModel.setDeadline(of: days)}
            }
        } label: {
            Text(viewModel.deadlineMenuTitle)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(viewModel.complimentaryColor)
                .cornerRadius(8)

        }
    }
}


struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(goal: GoalCreationModel.premadeGoals[0])
    }
}

struct ColoredCompactPickerStyle: DatePickerStyle {

    var color: Color

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .zero) {
            configuration.label

            Spacer()

            Text(configuration.selection.formatted(date: .abbreviated, time: .omitted))
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(color)
                .cornerRadius(8)
                .allowsHitTesting(false)
                .overlay {
                    DatePicker("", selection: configuration.$selection, displayedComponents: configuration.displayedComponents)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .blendMode(.destinationOver)
                        .tint(color)
                        .opacity(0.02)
                }
        }
    }
}
