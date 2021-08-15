//
//  IconsAndColorsView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/14/21.
//

import SwiftUI

enum ViewType: String {
    case colors = "Colors"
    case icons = "Icons"
}

struct IconsAndColorsView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    var columns = Array(repeating: GridItem(.flexible()), count: 4)
    var viewType: ViewType
    var colors = Colors.allCases
    var presentedItems: [PopOverContent]
    var screenSize: CGFloat
    var itemHeight: CGFloat
    
    
    init(_ vm: GoalViewModel, size: CGSize) {
        viewModel = vm
        viewType = vm.popOver
        screenSize = size.height
        
        switch viewType {
        case .colors:
            itemHeight = 25
            presentedItems = Colors.allCases.map { $0.rawValue == vm.selectedColor ? PopOverContent(content: $0.rawValue, isSelected: true) : PopOverContent(content: $0.rawValue) }
            
        case .icons:
            itemHeight = 35
            presentedItems = Icons.allCases.map { $0.rawValue == vm.selectedIcon ? PopOverContent(content: $0.rawValue, isSelected: true) : PopOverContent(content: $0.rawValue) }
        }
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: viewType == .colors ? screenSize * 0.3 : screenSize * 0.2 )
            VStack {
                Text(viewType.rawValue)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(presentedItems) { item in
                            
                            Image(viewType == .colors ? "circle" : item.content)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: itemHeight, height: itemHeight)
                                .padding()
                                .foregroundColor(color(for: item))
                                .background(item.isSelected ? Color(.tertiarySystemFill) : Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .onTapGesture { itemSelected(item) }
                        }
                    }
                }
            }
            .padding(.vertical)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(20)
            .padding()
            .padding(.bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: dismissView)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut)
        .zIndex(2)
    }
    
    
    func itemSelected(_ item: PopOverContent) {
        switch viewType {
        case .colors:
            viewModel.selectedColor = item.content
        case .icons:
            viewModel.selectedIcon = item.content
        }
        
        withAnimation { viewModel.isShowingPopOver = false }
    }
    
    
    func color(for item: PopOverContent) -> Color {
        switch viewType {
        case .colors:
            return Color(item.content)
        case .icons:
            return Color(Colors.allCases[item.index].rawValue)
        }
    }
    
    
    func dismissView() {
        withAnimation { viewModel.isShowingPopOver = false }
    }
}

struct IconsAndColorsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsAndColorsView(GoalViewModel(), size: UIScreen.main.bounds.size)
    }
}

struct PopOverContent: Identifiable {
    var id = UUID()
    var content: String
    var isSelected = false
    var index = Int.random(in: 0...Colors.allCases.count - 1 )
}
