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
    static let page1 = PageText(id: 1, image: IntroIllustrations.intro.image, title: "What Is SMART Planning?", text: "SMART Planning is an achieving goal system that proved it's effectiveness. \n\nS - Specific \nM - Measurable \nA - Achievable, \nR - Relevant \nT - Time-bound", color: Colors.brandBlue.color)
    static let page2 = PageText(id: 2, image: IntroIllustrations.specific.image, title: "A specific goal answers the following questions:", text: "• What steps will you take to achieve it? \n• Who is responsible for it? \n\nSometimes it's worth breaking a goal into a few subgoals.", color: Colors.brandGrassGreen.color)
    static let page3 = PageText(id: 3, image: IntroIllustrations.measurable.image, title: "There must be a criteria for measuring progress", text: "If there are no criteria, you will not be able to determine your progress and if you are on track to reach your goal. To make a goal measurable, ask yourself: \n\n• How many/much? \n• What is my indicator of progress? \n• How do I know if I have reached my goal?", color: Colors.brandRed.color)
    static let page4 = PageText(id: 4, image: IntroIllustrations.achievable.image, title: "Goals should be realistic", text: "Achievability means ensuring that your goal is within reach. Give yourself a serious reality check.  Is the goal you’ve outlined attainable? Is it something your team could actually accomplish? It’s important to consider any limitations that might impede your goal.", color: Colors.brandTurquoise.color)
    static let page5 = PageText(id: 5, image: IntroIllustrations.relevant.image, title: "The goal must be important to you", text: "That's what meant by 'relevant' here. During this step, you evaluate why the goal matters to you.", color: Colors.brandSkyBlue.color)
    static let page6 = PageText(id: 6, image: IntroIllustrations.timely.image, title: "Goals have deadlines", text: "If the goal is not time-constrained, there will be no sense of urgency and, therefore, less motivation to achieve the goal.", color: Colors.brandPurple.color)
    
    static let pages = [page1, page2, page3, page4, page5, page6]
}
