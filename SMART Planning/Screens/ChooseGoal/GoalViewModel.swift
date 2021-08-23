//
//  GoalViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import SwiftUI

final class GoalViewModel: ObservableObject {
    // MARK:  - Choose Goal View
    @Published var isShowingGoalView = false
    
    var goals = GoalCreationModel.premadeGoals
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
    
    // MARK:  - Goal View
    #warning("Make sure metric isn't 0")
    @Published var selectedMetric       = "2"
    @Published var selectedUnit         = "pages"
    @Published var selectedAction       = "Read"
    
    @Published var deadlineDate         = Date()
    @Published var days                 = Days.days
    
    @Published var goalTitle            = ""
    @Published var description          = "Description (Optional)"
    @Published var isTargetEdited       = false
    
    @Published var convertedToSingulars = false
    @Published var isShowingPopOver     = false
    @Published var isShowingDatePicker  = false
    @Published var selectedColor        = "brandBlue"
    @Published var selectedIcon         = "macbook"
    @Published var popOver: ViewType    = .colors
    @Published var notificationTime     : NotificationSegmentType = .dontNotify {
        didSet {
            if notificationTime != .dontNotify {
                requestAuthorization()
            }
        }
    }
    
    
    @Published var measurementUnits     = ["pages", "times", "minutes", "hours", "dollars", "kilograms", "kilometers", "miles", "meditations", "pounds", "pictures", "courses", "lessons", "credits"]
    
    var measurementActions = ["Read", "Drink", "Save", "Train", "Run", "Learn", "Pass", "Jog", "Exercise", "Paint", "Gain", "Complete", "Lose", "Make", "Draw", "Do", "Find"]
    
    var targetTitle: String { isTargetEdited ?  selectedAction + " " + selectedMetric + " " + selectedUnit : "Your target:" }
    
    var deadlineTitle: String {
        let isToday = Calendar.current.isDateInToday(deadlineDate)
        let title = Date().isDateThisYear(deadlineDate) ? deadlineDate.toString(.deadline) : deadlineDate.toString(.deadlineNextYear)
        return isToday ? "Deadline is not set" : "Deadline: \(title)"
    }
    
    var dateRange: ClosedRange<Date> {
        let now = Date().adding(days: -1)
        let nextYear = now.adding(days: 365)
        let range = now ... nextYear
        return range
    }
    
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [self] _ in
            withAnimation {
                if description == "Description (Optional)" {
                    description = ""
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [self] (noti) in
            withAnimation {
                if description == "" {
                    description = "Description (Optional)"
                }
            }
        }
    }
    
    func requestAuthorization() {
        NotificationManager.shared.schedule()
    }
    
  
    
    
    func convertSingularsAndPlurals() {
        isTargetEdited = true
        
        if convertedToSingulars {
            measurementUnits = measurementUnits.map { $0 + "s"}
            selectedUnit = selectedUnit + "s"
            convertedToSingulars = false
            
        } else if Int(selectedMetric) == 1 {
            measurementUnits = measurementUnits.map { String($0.dropLast()) }
            selectedUnit = String(selectedUnit.dropLast())
            convertedToSingulars = true
        }
    }
    
    
    func saveToCoreData() {
        guard let desiredResult     = Int(selectedMetric) else { return }
        let isDaily                 = days.filter { $0.isSelected }
        let goal                    = Goal(context: PersistenceManager.shared.viewContext)
        goal.id                     = UUID()
        goal.action                 = selectedAction.lowercased()
        goal.title                  = goalTitle
        goal.color                  = selectedColor
        goal.icon                   = selectedIcon
        goal.notificationHour       = Int16(notificationTime.hour)
        goal.notificationMinute     = Int16(Int.random(in: 1...59))
        goal.goalDescription        = description
        goal.baseProgress           = 0
        goal.desiredResult          = Double(desiredResult)
        goal.units                  = selectedUnit.lowercased()
        goal.daysOfPracticeAWeek    = Int16(isDaily.count)
        goal.startDate              = Date()
        goal.deadline               = deadlineDate
        
        for day in isDaily {
            let trainingDay         = TrainingDays(context: PersistenceManager.shared.viewContext)
            trainingDay.id          = UUID()
            trainingDay.day         = Int16(day.weekDay)
            trainingDay.goal        = goal
            goal.addToTrainingDays(trainingDay)
        }
        
        PersistenceManager.shared.save()
    }
    
    
    func iconsTapped() {
        withAnimation {
            popOver = .icons
            isShowingPopOver = true
        }
    }
    
    
    func colorsTapped() {
        withAnimation {
            popOver = .colors
            isShowingPopOver = true
        }
    }
    
    
    func showGoalView(goal: GoalCreationModel) {
        selectedUnit        = goal.unit
        selectedAction      = goal.action
        goalTitle           = goal.title
        selectedColor       = goal.randomColor
        
        isTargetEdited      = goal.action == "" ? false : true
        isShowingGoalView   = true
    }
}
