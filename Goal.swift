//
//  Goal.swift
//  SMART Planning
//
//  SwiftData model for goals
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class GoalColor {
    var red: Float
    var green: Float
    var blue: Float

    init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(resolved: Color.Resolved) {
        red = resolved.red
        green = resolved.green
        blue = resolved.blue
    }
}

@Model
final class Goal {
    
    var id: UUID
    var baseProgress: Double
    var currentProgress: Double
    var daysOfPracticeAWeek: Int
    var deadline: Date
    var desiredResult: Double
    var goalDescription: String
    var icon: String
    var startDate: Date
    var title: String
    var units: String
    var unitsShort: String
    var trainingDays: [Int]
    var allowNotifications: Bool
    var color: GoalColor
    @Relationship(deleteRule: .cascade)
    var exerciseDates: [Date]
    var completedExercises: [CompletedExercise]
    var notification: NotificationTime?
    
    init(
        id: UUID,
        baseProgress: Double,
        color: GoalColor,
        currentProgress: Double,
        daysOfPracticeAWeek: Int,
        deadline: Date,
        desiredResult: Double,
        goalDescription: String,
        icon: String,
        startDate: Date,
        title: String,
        units: String,
        unitsShort: String,
        trainingDays: [Int],
        allowNotifications: Bool,
        exerciseDates: [Date],
        notification: NotificationTime? = nil
    ) {
        self.id = id
        self.baseProgress = baseProgress
        self.color = color
        self.currentProgress = currentProgress
        self.daysOfPracticeAWeek = daysOfPracticeAWeek
        self.deadline = deadline
        self.desiredResult = desiredResult
        self.goalDescription = goalDescription
        self.icon = icon
        self.startDate = startDate
        self.title = title
        self.units = units
        self.unitsShort = unitsShort
        self.trainingDays = trainingDays
        self.allowNotifications = allowNotifications
        self.notification = notification
        self.exerciseDates = exerciseDates
        self.completedExercises = []
    }
}

@Model
final class CompletedExercise {
    var id: UUID
    var date: Date
    var progressCompleted: Double
    var progressBeforeTraining: Double
    var progressAfterTraining: Double
    
    @Relationship(inverse: \Goal.completedExercises)
    var goal: Goal
    
    init(id: UUID, date: Date, progressCompleted: Double, progressBefore: Double, progressAfter: Double, goal: Goal) {
        self.id = id
        self.date = date
        self.progressCompleted = progressCompleted
        self.progressBeforeTraining = progressBefore
        self.progressAfterTraining = progressAfter
        self.goal = goal
    }
}

extension Goal: Identifiable {}

extension Goal {
    func weeklyPerformance(completed dailyGoal: Double, completed: (Double, Double, Int, Int, Double, Double) -> Void) {
        let calendar = Calendar.current
        let sunday = Date().startOfWeek
        let weekDates = (0...6).map { sunday.adding(days: $0) }
        let weekKeys = Set(weekDates.map { $0.toString(.deadlineNextYear) })
        
        // Planned vs completed for this week
        let plannedDates = exerciseDates.filter { weekKeys.contains($0.toString(.deadlineNextYear)) }
        let completedThisWeek = completedExercises.filter { weekKeys.contains($0.date.toString(.deadlineNextYear)) }
        
        // Base = earliest "before" in week (fallback: current progress)
        let baseProgress = completedThisWeek
            .min(by: { $0.progressBeforeTraining < $1.progressBeforeTraining })?
            .progressBeforeTraining ?? currentProgress
        
        // Desired = latest "after" in week if exists, otherwise base + target for planned days (capped by desiredResult)
        let desiredFromCompletions = completedThisWeek
            .max(by: { $0.progressAfterTraining < $1.progressAfterTraining })?
            .progressAfterTraining
        
        let numberOfTasks = plannedDates.count
        let numberOfCompletedTasks = completedThisWeek.count
        
        // Weekly target/milestone derived from planned days
        let thisWeekMileStone = Double(numberOfTasks) * dailyGoal
        
        // Sum of actual completed progress this week
        let currentProgress = completedThisWeek
            .reduce(0) { $0 + $1.progressCompleted }
            .roundToDecimal(1)
        
        let desiredProgress = desiredFromCompletions ?? min(desiredResult, baseProgress + thisWeekMileStone)
        
        completed(baseProgress, desiredProgress, numberOfTasks, numberOfCompletedTasks, thisWeekMileStone, currentProgress)
    }
}
