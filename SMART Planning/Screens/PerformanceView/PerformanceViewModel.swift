//
//  PerformanceViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import Foundation


final class PerformanceViewModel: ObservableObject {
    
    @Published var goals = [GoalModel]()
    @Published var currentTab: SegmentedControlType = .weekly
    
    var performanceRangeTitle: String {
        switch currentTab {
        case .weekly:
            return weekRangeTitle
        case .monthly:
            return monthRangeTitle
        case .total:
          return ""
        }
    }
    
    var weekRangeTitle: String {
        let sunday = Date().startOfWeek
        let saturday = sunday.adding(days: 6)
        
        return sunday.toString(.deadline) + " – " + saturday.toString(.deadline)
    }
    
    var monthRangeTitle: String {
        let month = Date().datesOfMoths(of: .deadline)
        let firstDay = month.first ?? "Date Error"
        let lastDay = month.last ?? "Date Error"
        
        return firstDay + " – " + lastDay
    }
    
    func loadGoals(from brain: GoalsManager) {
        goals = brain.goals
    }
}
