//
//  File.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

import SwiftUI
import SwiftData

struct GoalModel: Identifiable {

    var id = UUID()
    var goal: Goal

    init(_ goal: Goal) {
        self.goal = goal
    }

    var complementaryColor: Color {
        Color(red: goal.color.red, green: goal.color.green, blue: goal.color.blue).opacity(0.3)
    }

    var totalNumberOfTasks: Int {
        let coef = Double(goal.daysOfPracticeAWeek) / 7.0
        let numberOfTasks = Int(numberOfDays * coef)
        return numberOfTasks
    }

    var dailyGoal: Double {
        let dailyGoal = (goal.desiredResult - goal.baseProgress) / numberOfDays
        let coef = 7.0 / Double(goal.daysOfPracticeAWeek)
        return coef * dailyGoal
    }

    var weeklyGoal: Double {
        dailyGoal * Double(goal.daysOfPracticeAWeek)
    }

    func createTasks(startDate: Date, dailyGoal: Double, startProgress: Double, using modelContext: ModelContext) {
        var date = startDate
        var currentProgress = startProgress
        var trainingDays: [Date] = []

        for _ in 0..<Int(numberOfDays) {
            for day in goal.trainingDays {
                if day == Calendar.current.component(.weekday, from: date) {
                    trainingDays.append(date)
                    break
                }
            }

            date = date.adding(days: 1)

            while !goal.trainingDays.contains(Calendar.current.component(.weekday, from: date)) {
                date = date.adding(days: 1)
            }
        }

        try? modelContext.save()
    }

    var numberOfDays: TimeInterval {
        Double(goal.deadline.days(from: goal.startDate))
    }
}


//    // MARK: -  Performance View
//extension GoalModel {
//
//    func weeklyPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
//        let calendar = Calendar.current
//        let startOfWeek = Date().startOfWeek
//        let weekDates = (0...6).map { startOfWeek.adding(days: $0) }
//        let weekKeys = Set(weekDates.map { $0.toString(.deadlineNextYear) })
//
//        // Planned vs completed for this week
//        let plannedDates = goal.exerciseDates.filter { weekKeys.contains($0.toString(.deadlineNextYear)) }
//        let completedThisWeek = goal.completedExercises.filter { weekKeys.contains($0.date.toString(.deadlineNextYear)) }
//
//        // Base = earliest "before" in week (fallback: current progress)
//        let baseProgress = completedThisWeek
//            .min(by: { $0.progressBeforeTraining < $1.progressBeforeTraining })?
//            .progressBeforeTraining ?? goal.currentProgress
//
//        // Desired = latest "after" in week if exists, otherwise base + target for planned days (capped by goal.desiredResult)
//        let desiredFromCompletions = completedThisWeek
//            .max(by: { $0.progressAfterTraining < $1.progressAfterTraining })?
//            .progressAfterTraining
//
//        let numberOfTasks = plannedDates.count
//        let numberOfCompletedTasks = completedThisWeek.count
//
//        // Weekly target/milestone derived from planned days
//        let thisWeekMileStone = Double(numberOfTasks) * dailyGoal
//
//        // Sum of actual completed progress this week
//        let currentProgress = completedThisWeek
//            .reduce(0) { $0 + $1.progressCompleted }
//            .roundToDecimal(1)
//
//        let desiredProgress = desiredFromCompletions ?? min(goal.desiredResult, baseProgress + thisWeekMileStone)
//
//        completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisWeekMileStone, currentProgress)
//    }
//
//
//    func monthlyPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
//        let datesOfMoths = Date().datesOfMoths(of: .deadlineNextYear)
//        let thisMonthTasks = tasks.filter { datesOfMoths.contains($0.wrappedDate.toString(.deadlineNextYear))}
//
//        let baseProgress = thisMonthTasks.min()?.resultBeforeTraining ?? 0
//        let desiredProgress = thisMonthTasks.max()?.resultAfterTraining ?? 0
//        let numberOfTasks = thisMonthTasks.count
//        let numberOfCompletedTasks = thisMonthTasks.filter { $0.isCompleted }.count
//        let thisMonthMileStone = thisMonthTasks.reduce(0) { $0 + $1.trainingAmount }
//        let currentProgress = thisMonthTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.trainingAmount }
//
//        completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisMonthMileStone, currentProgress)
//    }
//
//
//    func totalPerformance(completed: @escaping (Double, Double, Int, Int, Double, Double) -> Void) {
//        let numberOfTasks = tasks.count
//        let numberOfCompletedTasks = tasks.filter { $0.isCompleted }.count
//
//        completed(goal.baseProgress, goal.desiredResult, numberOfTasks, numberOfCompletedTasks, goal.desiredResult, goal.currentProgress)
//    }
//}

extension GoalModel: StepperData {

    var startDate: Date {
        goal.startDate
    }


    var baseProgress: Double {
        goal.baseProgress
    }


    var daysPerStep: Double {
        numberOfDays / Double(numberOfSteps - 1)
    }


    var numberOfSteps: Int {
        return min(7, max(Int(numberOfDays / 30), 5))
    }


    var goalPerStep: Double {
        (goal.desiredResult - goal.baseProgress) / Double(numberOfSteps - 1)
    }


    var spacing: Spacing {
        if numberOfSteps == 7 {
            return .sevenSteps
        } else if numberOfSteps == 6 {
            return .sixSteps
        } else {
            return .fiveSteps
        }
    }


    var shouldExpand: Bool {
       true
    }


    var color: GoalColor {
        goal.color
    }

    var displayUnits: String {
        goal.unitsShort
    }
}
