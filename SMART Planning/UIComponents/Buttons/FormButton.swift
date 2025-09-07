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
    var tapAction: (() -> Void)?
    
    var iconSize: CGFloat = 40

    var body: some View {
        if buttonType == .colors {
            ColorPicker(selection: $viewModel.selectedColor) { EmptyView() }
                .labelsHidden()
                .scaleEffect(CGSize(width: 1.35, height: 1.35))
                .frame(maxWidth: .infinity, maxHeight: iconSize)
        } else {
            Image(viewModel.selectedIcon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(viewModel.selectedColor)
                .padding(.space8)
                .background(viewModel.complimentaryColor)
                .clipShape(RoundedRectangle(cornerRadius: iconSize / 2))
                .frame(width: iconSize, height: iconSize)
                .frame(maxWidth: .infinity)
                .onTapGesture(perform: buttonAction)
        }
    }
    
    func buttonAction() {
        tapAction?()
    }
}

struct FormButton_Previews: PreviewProvider {
    static var previews: some View {
        FormButton(buttonType: .icons) { }.environmentObject(GoalViewModel())
    }
}
