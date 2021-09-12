//
//  Image + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import SwiftUI

extension Image {
    func iconStyle(with size: CGFloat) -> some View {
        self
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
    
    func performanceIconStyle(with color: String) -> some View {
        self
            .iconStyle(with: 16)
            .padding(.horizontal, 5)
            .foregroundColor(Color(color))
    }
}


