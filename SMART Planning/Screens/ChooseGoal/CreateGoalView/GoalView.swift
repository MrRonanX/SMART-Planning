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
            Background {
                GeometryReader { geo in
                    ZStack {
                        FormWithoutHeader {
                            Section {
                                TextField("Goal Title", text: $viewModel.goalTitle)
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
                        .environmentObject(viewModel)
                    }
                    if viewModel.isShowingPopOver {
                        FullScreenBlackTransparencyView()
                        IconsAndColorsView(viewModel, size: geo.size)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: dismissView) { Text("Dismiss") }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: saveGoal) { Text("Save") }
                    }
                }
            }
            
            .onTapGesture(perform: dismissKeyboard)
        }
        .accentColor(Color(viewModel.selectedColor))        
    }

    
    
    func saveGoal() {
        viewModel.saveToCoreData()
        presentationMode.wrappedValue.dismiss()
    }
    
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
}



fileprivate struct GoalTarget: View {
    @EnvironmentObject var viewModel: GoalViewModel
    var size: CGSize
    
    var body: some View {
        HStack {
            Picker("", selection: $viewModel.selectedAction) {
                ForEach(viewModel.measurementActions, id:\.self) {
                    Text("\($0)")
                }
            }
            .frame(width: size.width / 3 - 40)
            .clipped()
            
            TextField("Desired Result", text: $viewModel.selectedMetric)
                .keyboardType(.numberPad)
                .overlay(textFieldBorder)
                .onChange(of: Int(viewModel.selectedMetric), perform: { _ in viewModel.convertSingularsAndPlurals() })
            
            Picker("", selection: $viewModel.selectedUnit) {
                ForEach(viewModel.measurementUnits, id:\.self) {
                    Text("\($0)")
                }
            }
            .frame(width: size.width / 3 - 40)
            .clipped()
        }
        .pickerStyle(WheelPickerStyle())
    }
    
    
    var textFieldBorder: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
        }
        .padding(.vertical, -5)
    }
}


fileprivate struct ExpandableCell: View {
    @EnvironmentObject var viewModel: GoalViewModel
    @State var isExpanded = false
    @State var rotationDegrees = 0.0
    
    var title: String {
        let selectedCount = viewModel.days.filter { $0.isSelected }.count
        return selectedCount == 7 ? "Everyday" : viewModel.days.filter { $0.isSelected }.map { $0.longTitle}.joined(separator: ", ")
    }
    
    var body: some View {
        HStack {
            Text(title).font(.title3)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 15, height: 15)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation { isExpanded.toggle() } }
        .animation(.default)
        .onChange(of: isExpanded, perform: { _ in rotationDegrees += 180 })
        
        if isExpanded {
            HStack {
                Spacer()
                ForEach(viewModel.days) { item in
                    DayCircle(day: item)
                        .onTapGesture { toggleDaySelection(for: item) }
                }
                Spacer()
            }.padding(.vertical, 7)
        }
    }
    
    
    func toggleDaySelection(for day: DayCircleModel) {
        guard let index = viewModel.days.firstIndex(where: { $0.id.uuidString == day.id.uuidString }) else { return }
        viewModel.days[index].isSelected.toggle()
    }
}


fileprivate struct DayCircle: View {
    
    @EnvironmentObject var viewModel: GoalViewModel
    var day: DayCircleModel
    
    var body: some View {
        Circle()
            .frame(width: 34, height: 34)
            .foregroundColor(day.isSelected ? Color(viewModel.selectedColor) : .secondary)
            .overlay(
                Text(day.title)
                    .font(.headline)
                    .foregroundColor(.white)
            )
    }
}


fileprivate struct FullScreenBlackTransparencyView: View {
    
    var body: some View {
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.9)
            .transition(.opacity)
            .animation(.easeOut)
            .zIndex(1)
            .accessibilityHidden(true)
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
            .preferredColorScheme(.dark)
    }
}
