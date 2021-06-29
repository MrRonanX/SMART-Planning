//
//  StepperImageView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/29/21.
//

import SwiftUI

struct StepperImageView: View {
    var name:String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.white)
                .overlay(Image(name)
                            .resizable()
                            .frame(width: 30, height: 30))
                .frame(width: 40, height: 40)
        }
        
    }
}
