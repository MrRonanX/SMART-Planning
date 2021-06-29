//
//  ContentView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI



struct IntroView: View {
    
    let text = PageTextContent()
    @State var nextButtonShown = false
    
    var body: some View {
        GeometryReader { geo in
            body(for: geo.size.width)
        }


    }
    
    func body(for size: CGFloat) -> some View {
        NavigationView {
            VStack {
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size / 2)
                Text("What is SMART planning?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                TabView {
                    ForEach(text.pages) { content in
                        Text(content.text)
                            .font(.body)
                            .padding()
                    }
                }.tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                Spacer()
                NavigationLink(
                    destination: RecurringEventsView()) {
                        Text("Skip")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .background(Color.clear)
                            .cornerRadius(20)
                            .padding()
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
