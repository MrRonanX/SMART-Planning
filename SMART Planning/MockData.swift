//
//  MockData.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import Foundation


struct PageText: Identifiable {
    var id: Int
    var text: String
}

struct PageTextContent {
    static let page1 = PageText(id: 1, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget odio eu odio suscipit viverra. Donec efficitur, elit nec sagittis vulputate, metus eros suscipit velit, sit amet cursus risus elit id odio. Nulla facilisi. Maecenas ac feugiat diam, id vehicula ante.")
    static let page2 = PageText(id: 2, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc euismod risus magna, quis congue mauris eleifend ut. Morbi tellus orci, lobortis et lacus a, imperdiet rutrum dolor. Duis neque enim.")
    static let page3 = PageText(id: 3, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus cursus maximus diam, sit amet sodales tellus gravida eu. Morbi nec nulla erat. Vestibulum efficitur turpis et fringilla ornare. Nullam dapibus, lorem ut feugiat condimentum, ante ex tristique ante, eu semper.")
    static let page4 = PageText(id: 4, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris varius non turpis id iaculis. Morbi congue commodo accumsan. Ut magna risus, condimentum eget facilisis in, semper id justo. In nec magna risus. Vestibulum dictum consectetur finibus. Phasellus.")
    
    let pages = [page1, page2, page3, page4]
}
