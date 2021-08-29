//
//  MockData.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import Foundation


struct PageText: Identifiable {
    var id: Int
    var image: String
    var title: String
    var text: String
    var color: String
}

struct PageTextContent {
    static let page1 = PageText(id: 1, image: Illustrations.becomeSmarter.image, title: "What Is SMART Planning?", text: "SMART Planning is an achieving goal system that proved it's effectiveness. \nS - Specific \nM - Measurable \nA - Achievable, \nR - Relevant \nT - Time-bound", color: Colors.brandBlue.color)
    static let page2 = PageText(id: 2, image: Illustrations.enlightenment.image, title: "Lorem ipsum dolor sit", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc euismod risus magna, quis congue mauris eleifend ut. Morbi tellus orci, lobortis et lacus a, imperdiet rutrum dolor. Duis neque enim.", color: Colors.brandGrassGreen.color)
    static let page3 = PageText(id: 3, image: Illustrations.idea.image, title: "Lorem ipsum dolor sit", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus cursus maximus diam, sit amet sodales tellus gravida eu. Morbi nec nulla erat. Vestibulum efficitur turpis et fringilla ornare. Nullam dapibus, lorem ut feugiat condimentum, ante ex tristique ante, eu semper.", color: Colors.brandRed.color)
    static let page4 = PageText(id: 4, image: Illustrations.learnLanguage.image, title: "Lorem ipsum dolor sit", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris varius non turpis id iaculis. Morbi congue commodo accumsan. Ut magna risus, condimentum eget facilisis in, semper id justo. In nec magna risus. Vestibulum dictum consectetur finibus. Phasellus.", color: Colors.brandTurquoise.color)
    
    static let pages = [page1, page2, page3, page4]
}
