//
//  GoalViewModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import SwiftUI

final class GoalViewModel: ObservableObject {
    enum Mode { case creating, editing }
    // MARK:  - Choose Goal View
    @Published var isShowingGoalView = false
    
    var goals = GoalCreationModel.premadeGoals
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    // MARK:  - Goal View
    
    @Published var selectedMetric        = "2"
    @Published var selectedUnit          = "pages"
    @Published var selectedAction        = "Read"
     
    @Published var deadlineDate          = Date()
    @Published var days                  = Days.days
     
    @Published var goalTitle             = ""
    @Published var description           = "Description (Optional)"
    @Published var isTargetEdited        = false
     
    @Published var convertedToSingulars  = false
    @Published var isShowingPopOver      = false
    @Published var isShowingDatePicker   = false
    @Published var selectedColor         = "brandBlue"
    @Published var selectedIcon          = "macbook"
    @Published var popOver: ViewType     = .colors
    @Published var notificationTime      : NotificationSegmentType = .dontNotify
    @Published var alertItem             : AlertItem? = nil
    @Published var showCustomActionAlert = false
    @Published var showCustomUnitAlert   = false
    
    
    @Published var measurementUnits      = ["pages", "times", "minutes", "hours", "dollars", "kilograms", "kilometers", "miles", "meditations",
                                           "pounds", "pictures", "courses", "lessons", "credits"]
    
    @Published var measurementActions    = ["Read", "Drink", "Save", "Train", "Run", "Learn", "Pass", "Jog", "Exercise", "Paint", "Gain", "Complete",
                                           "Lose", "Make", "Draw", "Do", "Find"]
    
    var goalShortcut                    = [365, 300, 250, 200, 150, 100]
    var goalIsSet                       = false
    var mode: Mode                      = .creating
    var selectedGoal                    : Goal?
    var targetTitle: String { isTargetEdited ?  selectedAction + " " + selectedMetric + " " + selectedUnit : "Your target:" }
    
    var deadlineTitle: String {
        let isToday = Calendar.current.isDateInToday(deadlineDate)
        let title = Date().isDateThisYear(deadlineDate) ? deadlineDate.toString(.deadline) : deadlineDate.toString(.deadlineNextYear)
        return isToday ? "Deadline is not set" : title
    }
    
    var dateRange: ClosedRange<Date> {
        let now = Date()
        let nextYear = now.adding(days: 365)
        let range = now ... nextYear
        return range
    }
    
    
    var deadlineMenuTitle: String {
        let range = deadlineDate.days(from: Date())
        let plurality = range > 1 ? "Days" : "Day"
        let title = range == 365 ? "1 Year" : "\(range) \(plurality)"
        return range > 0 ? title : "Set"
    }
    
    
    var descriptionColor: Color {
        description == "Description (Optional)" ? .gray : Color(.label)
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
    
    
    func isValid() -> Bool {
        guard !selectedMetric.isEmpty || selectedMetric == "0" else {
            alertItem = AlertContext.notValid("desired result")
            return false
        }
        
        guard !selectedUnit.isEmpty else {
            alertItem = AlertContext.notValid("unit")
            return false
        }
        
        guard !selectedAction.isEmpty else {
            alertItem = AlertContext.notValid("action")
            return false
        }
        
        guard deadlineDate.midday() != Date().midday() else {
            alertItem = AlertContext.notValid("deadline")
            return false
        }
        
        guard days.count > 0 else {
            alertItem = AlertContext.notValid("practice days")
            return false
        }
        
        return true
    }
    
    
    func saveToCoreData() {
        guard isValid() else { return }
        mode == .creating ? createCoreDataObject() : updateGoal()
        
        PersistenceManager.shared.save()
        isShowingGoalView   = false
        goalIsSet           = true
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
    
    
    func setDeadline(of days: Int) {
        deadlineDate = Date().adding(days: days)
    }
    
    
    func actionAlertDismissed() {
        if !measurementActions.contains(selectedAction) && !selectedAction.isEmpty {
            selectedAction = selectedAction.capitalized
            withAnimation { measurementActions.append(selectedAction.capitalized) }
        }
    }
    
    
    func unitAlertDismissed() {
        if !measurementUnits.contains(selectedUnit) && !selectedUnit.isEmpty {
            selectedUnit = selectedUnit.lowercased()
            withAnimation { measurementUnits.append(selectedUnit.lowercased()) }
        }
    }
    
    
    func showGoalView(for goal: GoalCreationModel) {
        selectedUnit        = goal.unit
        selectedAction      = goal.action
        goalTitle           = goal.title
        selectedColor       = goal.randomColor
        days                = Days.days
        mode                = .creating
        isTargetEdited      = goal.action == "" ? false : true
        isShowingGoalView   = true
    }
    
    
    func setupEditingView(with goalModel: GoalModel) {
        selectedUnit        = goalModel.goal.wrappedUnits
        selectedAction      = goalModel.goal.wrappedAction.capitalized
        goalTitle           = goalModel.goal.wrappedTitle
        selectedColor       = goalModel.goal.wrappedColor
        selectedMetric      = String(Int(goalModel.goal.desiredResult))
        selectedIcon        = goalModel.goal.wrappedIcon
        description         = goalModel.goal.wrappedGoalDescription
        deadlineDate        = goalModel.goal.wrappedDeadline
        mode                = .editing
        selectedGoal        = goalModel.goal
        
        for (index, day) in days.enumerated() {
            if !goalModel.goal.wrappedTrainingDays.contains(day.weekDay) {
                days[index].isSelected = false
            }
        }
        
        isTargetEdited      = true
        isShowingGoalView   = true
    }
    
    
    private func updateGoal() {
        guard let desiredResult     = Int(selectedMetric) else { return }
        let goalDescription         = "\(selectedAction.capitalized) \(selectedMetric) \(selectedUnit)"
        let agreeToNotifications    = notificationTime != .dontNotify
        let shortUnit               = MeasurementUnit.measurementUnits.filter { $0.displayTitle.contains(selectedUnit) }.first?.shortTitle ?? selectedUnit.prefix(1).lowercased()
        let isDaily                 = days.filter { $0.isSelected }
        
        guard let goal              = selectedGoal else { return }
        goal.action                 = selectedAction.lowercased()
        goal.title                  = goalTitle
        goal.color                  = selectedColor
        goal.icon                   = selectedIcon
        goal.allowNotifications     = agreeToNotifications
        goal.goalDescription        = goalDescription
        goal.userDescription        = description
        goal.desiredResult          = Double(desiredResult)
        goal.units                  = selectedUnit.lowercased()
        goal.unitsShort             = shortUnit
        goal.daysOfPracticeAWeek    = Int16(isDaily.count)
        goal.deadline               = deadlineDate
        goal.trainingDays           = isDaily.map { Int16($0.weekDay) }
    }
    
    
    private func createCoreDataObject() {
        guard let desiredResult     = Int(selectedMetric) else { return }
        let goalDescription         = "\(selectedAction.capitalized) \(selectedMetric) \(selectedUnit)"
        let agreeToNotifications    = notificationTime != .dontNotify
        let shortUnit               = MeasurementUnit.measurementUnits.filter { $0.displayTitle.contains(selectedUnit) }.first?.shortTitle ?? selectedUnit.prefix(1).lowercased()
        let isDaily                 = days.filter { $0.isSelected }
        
        let goal                    = Goal(context: PersistenceManager.shared.viewContext)
        goal.id                     = UUID()
        goal.action                 = selectedAction.lowercased()
        goal.title                  = goalTitle
        goal.color                  = selectedColor
        goal.icon                   = selectedIcon
        goal.allowNotifications     = agreeToNotifications
        goal.goalDescription        = goalDescription
        goal.userDescription        = description
        goal.baseProgress           = 0
        goal.desiredResult          = Double(desiredResult)
        goal.units                  = selectedUnit.lowercased()
        goal.unitsShort             = shortUnit
        goal.daysOfPracticeAWeek    = Int16(isDaily.count)
        goal.startDate              = Date()
        goal.deadline               = deadlineDate
        goal.trainingDays           = isDaily.map { Int16($0.weekDay) }
        goal.currentProgress        = 0.0
        
        if agreeToNotifications {
            let notification = NotificationTime(context: PersistenceManager.shared.viewContext)
            notification.hour       = Int16(notificationTime.hour)
            notification.minute     = Int16(Int.random(in: 1...59))
            goal.notification       = notification
        }
    }
}

