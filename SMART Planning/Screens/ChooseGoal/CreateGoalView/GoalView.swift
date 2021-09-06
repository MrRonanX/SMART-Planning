//
//  GoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//


import SwiftUI

struct GoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GoalViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                FormWithoutHeader {
                    
                    Section {
                        TextField("Your Goal", text:  $viewModel.goalTitle, onCommit: dismissKeyboard)
                        TextEditor(text: $viewModel.description)
                            .frame(height: 100, alignment: .top)
                            .foregroundColor(viewModel.descriptionColor)
                            .onAppear(perform: viewModel.addObservers)
                    }
                    
                    HStack {
                        FormButton(buttonType: .icons, tapAction: viewModel.iconsTapped)
                        FormButton(buttonType: .colors, tapAction: viewModel.colorsTapped)
                    }
                    .padding(.leading, -20)
                    .listRowBackground(Color(.rowBackground))
                    
                    Section {
                        DaySelectionView()
                        Text(viewModel.targetTitle)
                        GoalTargetView(size: geo.size)
                    }
                    
                    Section(header: Text("")) {
                        NotificationTimeView()
                        HStack {
                            Text(viewModel.deadlineTitle)
                            Spacer()
                            DeadlineMenu()
                        }
                        DatePicker("Deadline", selection: $viewModel.deadlineDate, in: viewModel.dateRange, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(Color(viewModel.selectedColor))
                    }
                }
                .zIndex(0)
                
                if viewModel.isShowingPopOver {
                    FullScreenBlackTransparencyView()
                    IconsAndColorsView(viewModel, size: geo.size)
                }
            }
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(viewModel.goalTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.saveToCoreData) { Text("Save") }
            }
        }
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
                .font(.subheadline.bold())
                .lineLimit(2)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(Color(viewModel.selectedColor))
                .cornerRadius(9)
                
        }
    }
}


struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}


