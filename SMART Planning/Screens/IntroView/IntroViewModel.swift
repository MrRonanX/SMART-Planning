//
//  IntroViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/29/21.
//

import SwiftUI

final class IntroViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var hasSeenIntro: Bool
    var pages = PageTextContent.pages
    
    init(_ hasSeenIntro: Bool) {
        self.hasSeenIntro = hasSeenIntro
    }
    
    
    func width(for screenWidth: CGFloat, and position: Int) -> CGFloat {
        getIndex(for: screenWidth) == position ? 20 : 7
    }
    
    
    func getIndicatorOffset(for screenWidth: CGFloat) -> CGFloat {
        let progress = offset / screenWidth
        let maxWidth: CGFloat = 12 + 7
        return progress * maxWidth
    }
    
    
    func getIndex(for screenWidth: CGFloat) -> Int {
        let progress = round(offset / screenWidth)
        let index = min(Int(progress), pages.count - 1)
        return index
    }
    
    
    func nextPage(for screenWidth: CGFloat) {
        let currentIndex = getIndex(for: screenWidth) + 1
        if currentIndex == pages.count {
            withAnimation { hasSeenIntro = true }
            return
        }
        let index = min(currentIndex, pages.count - 1)
        offset = CGFloat(index) * screenWidth
    }
    
    
    func getButtonColor(for screenWidth: CGFloat) -> String {
        pages[getIndex(for: screenWidth)].color
    }
}
