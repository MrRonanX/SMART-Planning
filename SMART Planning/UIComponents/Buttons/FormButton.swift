//
//  FormButton.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/14/21.
//

import SwiftUI

struct FormButton: View {
    @EnvironmentObject var viewModel: GoalViewModel
    var buttonType: ViewType
    var tapAction: () -> Void
    
    var iconSize: CGFloat { buttonType == .colors ? 25 : 35 }
    
    var body: some View {
        HStack {
            Image(buttonType == .colors ? "circle" : viewModel.selectedIcon)
                .iconStyle(with: iconSize)
                .foregroundColor(Color(viewModel.selectedColor))
                .padding()
                .background(Color(.iconBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture(perform: buttonAction)
            
            Text(buttonType.rawValue)
                .font(.title3)
            
            Spacer()
        }
    }
    
    func buttonAction() {
        tapAction()
    }
}

struct FormButton_Previews: PreviewProvider {
    static var previews: some View {
        FormButton(buttonType: .icons) { }.environmentObject(GoalViewModel())
    }
}
