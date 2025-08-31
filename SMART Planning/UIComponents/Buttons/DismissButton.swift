//
//  DismissButton.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/26/21.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 44, height: 44)
            }
        }
    }
}


