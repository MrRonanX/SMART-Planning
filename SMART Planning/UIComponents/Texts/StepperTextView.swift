//
//  StepperTextView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/29/21.
//

import SwiftUI

struct StepperTextView: View {
    /// placeholder for text
    var text:String
    /// variable to hold font type
    var font:Font
    
    /// initilzes `text` and  `font`
    init(text:String, font:Font = .caption) {
        self.text = text
        self.font = font
    }
    
    /// provides the content and behavior of this view.
    var body: some View {
        Text(text)
            .font(font)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
            .padding(.leading)
            .padding(.leading, 5)
    }
}
