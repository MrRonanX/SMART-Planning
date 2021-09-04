//
//  ContentView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: IntroViewModel

    var body: some View {
            GeometryReader { geo in
                VStack {
                    OffsetPageTabView(offset: $viewModel.offset, screenWidth: geo.size.width) {
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: IntroViewModel())
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
                VStack(spacing: dynamicSpacing) {
                    Image(page.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.8)
                    
                    VStack(alignment: .leading, spacing: 22) {
                        Text(page.title)
                            .font(.title.bold())
                            .fixedSize(horizontal: false, vertical: true)
                        Text(page.text)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                    }
                    Spacer()
                }
                .padding()
                .frame(width: screenWidth)
            }
        }.padding(.top, 20)
    }
    
    var dynamicSpacing: CGFloat {
        DeviceTypes.isiPhone8Standard ? 20 : 50
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
