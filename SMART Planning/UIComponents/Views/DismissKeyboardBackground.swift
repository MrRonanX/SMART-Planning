//
//  DismissKeyboardBackground.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import SwiftUI

struct Background<Content: View>: View {
    
    private var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
            content
        }
    }
}

struct DismissKeyboardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Background { Text("Hello World") }
    }
}
