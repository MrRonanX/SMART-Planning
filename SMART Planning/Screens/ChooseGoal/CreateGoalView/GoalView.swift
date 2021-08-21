//
//  GoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//


import SwiftUI

struct GoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GoalViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    FormWithoutHeader {
                        
                        Section {
                            TextField("Your Goal", text:  $viewModel.goalTitle, onCommit: dismissKeyboard)
                            TextEditor(text: $viewModel.description)
                                .frame(height: 100, alignment: .top)
                                .foregroundColor(viewModel.description == "Description (Optional)" ? .gray : Color(.label))
                                .onAppear(perform: viewModel.addObservers)
                        }
                        
                        HStack {
                            FormButton(buttonType: .icons, tapAction: viewModel.iconsTapped)
                            FormButton(buttonType: .colors, tapAction: viewModel.colorsTapped)
                        }
                        .padding(.leading, -20)
                        .listRowBackground(Color(.rowBackground))
                        
                        Section {
                            ExpandableCell()
                            Text(viewModel.targetTitle)
                            GoalTarget(size: geo.size)
                            Text(viewModel.deadlineTitle)
                            DatePicker("Deadline", selection: $viewModel.deadlineDate, in: viewModel.dateRange, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        
                    }
                    .zIndex(0)
                    .environmentObject(viewModel)
                    
                    if viewModel.isShowingPopOver {
                        FullScreenBlackTransparencyView()
                        IconsAndColorsView(viewModel, size: geo.size)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(viewModel.goalTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveGoal) { Text("Save") }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: dismissView) { Text("Back") }
                }
                
            }
        }.accentColor(Color(viewModel.selectedColor))
    }
    
    
    func saveGoal() {
        viewModel.saveToCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
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


struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(viewModel: GoalViewModel())
    }
}
