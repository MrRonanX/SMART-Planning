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
    @State var daysTillDeadline = 0
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
                        DaySelectionCell()
                        Text(viewModel.targetTitle)
                        GoalTargetCell(size: geo.size)
                    }
                    
                    Section(header: Text("")) {
                        NotificationCell()
                        HStack {
                            Text(viewModel.deadlineTitle)
                            Spacer()

                            Menu {
                                Button("100 Days") { viewModel.setDeadline(of: 100) }
                                Button("150 Days") { viewModel.setDeadline(of: 150) }
                                Button("200 Days") { viewModel.setDeadline(of: 200) }
                                Button("250 Days") { viewModel.setDeadline(of: 250) }
                                Button("300 Days") { viewModel.setDeadline(of: 300) }
                                Button("1 Year") { viewModel.setDeadline(of: 365) }

                            } label: {
                                Text(viewModel.deadlineMenuTitle)
                                    .font(.subheadline.bold())
                                    .lineLimit(2)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                    .background(Color(viewModel.selectedColor))
                                    .cornerRadius(9)
                            }
                        }
                        DatePicker("Deadline", selection: $viewModel.deadlineDate, in: viewModel.dateRange, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(Color(viewModel.selectedColor))
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
        }
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


