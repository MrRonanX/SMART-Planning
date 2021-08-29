//
//  ContentView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

struct IntroView: View {
    @StateObject private var viewModel: IntroViewModel
    
    init(showOverlay: Bool) {
        _viewModel = StateObject(wrappedValue: IntroViewModel(showOverlay))
    }
    
    var body: some View {
        if viewModel.showOverlay {
            GeometryReader { geo in
                VStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .foregroundColor(.brandBlue)
                        .frame(width: 30, height: 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .top])
                    
                    OffsetPageTabView(offset: $viewModel.offset) {
                        ImageAndDescriptionView(screenWidth: geo.size.width)
                    }
                    
                    HStack(alignment: .bottom) {
                        
                        MovingIndicatorView(screenWidth: geo.size.width)
                        
                        Spacer()
                        
                        NextButton(screenWidth: geo.size.width)
                        
                    }
                    .padding()
                    .offset(y: -20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .animation(.easeInOut, value: viewModel.getIndex(for: geo.size.width))
                .environmentObject(viewModel)
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(showOverlay: true)
    }
}

struct NextButton: View {
    @EnvironmentObject var viewModel: IntroViewModel
    var screenWidth: CGFloat
    
    var body: some View {
        Button { viewModel.nextPage(for: screenWidth) } label: {
            Image(systemName: "chevron.right")
                .font(.title2.bold())
                .foregroundColor(Color(.white))
                .padding()
                .background(buttonBackgroundColor)
        }
    }
    
    var buttonBackgroundColor: some View {
        Color(viewModel.getButtonColor(for: screenWidth)).clipShape(Circle())
    }
}


struct ImageAndDescriptionView: View {
    @EnvironmentObject var viewModel: IntroViewModel
    var screenWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.pages) { page in
                VStack(spacing: 50) {
                    Image(page.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.8)
                    
                    VStack(alignment: .leading, spacing: 22) {
                        Text(page.title)
                            .font(.largeTitle.bold())
                        
                        Text(page.text)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(width: screenWidth)
            }
        }
    }
}

struct MovingIndicatorView: View {
    @EnvironmentObject var viewModel: IntroViewModel
    var screenWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(viewModel.pages.indices) { index in
                Capsule()
                    .fill(Color(.systemBlack))
                    .frame(width: viewModel.width(for: screenWidth, and: index), height: 7)
            }
        }
        .overlay(overlayCapsule() ,alignment: .leading)
        .offset(x: 10, y: -15)
    }
    
    func overlayCapsule() -> some View {
        Capsule()
            .fill(Color(.systemBlack))
            .frame(width: 20, height: 7)
            .offset(x: viewModel.getIndicatorOffset(for: screenWidth))
    }
}
