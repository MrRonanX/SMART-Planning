//
//  Icons.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/14/21.
//

import SwiftUI

enum Icons: String, CaseIterable {
    case briefcase = "briefcase"
    case book = "book"
    case graduationHat = "graduationHat"
    case brain = "brain"
    case bookA = "bookA"
    case paintBrushWide = "paintBrushWide"
    case paintBrush = "paintBrush"
    case gym = "gym"
    case banknote = "banknote"
    case currency = "currency"
    case coins = "coins"
    case laptop = "laptop"
    case macbook = "macbook"
    case desktop = "desktop"
    case paper = "paper"
    case pen = "pen"
    case chat = "chat"
    case chats = "chats"
    case call = "call"
    case phone = "phone"
    case mobile = "mobile"
    case waterDrop = "waterDrop"
    case waterBottle = "waterBottle"
    case dumbbell = "dumbbell"
    case weightLift = "weightLift"
    case skating = "skating"
    case cycling = "cycling"
    case swimming = "swimming"
    case award = "award"
    case checkmarkCircle = "checkmarkCircle"
    case heart = "heart"
    case idea = "idea"
    case location = "location"
    case start = "start"
    case eat = "eat"
    case communication = "communication"
    case cocktail = "cocktail"
    case notification = "notification"
    
    var icon: String {
        self.rawValue
    }
}

enum Illustrations {
    static let becomingSmarter = "becomingSmarter"
    static let enlightenment = "enlightenment"
    static let buildingMuscles = "buildingMuscles"
    static let gettingFit = "gettingFit"
    static let idea = "ideaIllustration"
    static let improveArt = "improveArt"
    static let learningLanguage = "learningLanguage"
    static let learningNewSkill = "learningNewSkill"
    static let losingWeight = "losingWeight"
    static let reading = "reading"
    static let savingMoney = "savingMoney"
    static let createGoal = "createGoal"
}

enum IntroIllustrations {
    static let achievable = "achievable"
    static let intro = "intro"
    static let measurable = "measurable"
    static let relevant = "relevant"
    static let specific = "specific"
    static let timely = "timely"
}

enum GoalDetails {
    static let baseProgress = "baseProgress"
    static let currentProgress = "currentProgress"
    static let deadline = "deadline"
    static let desiredResult = "desiredResult"
    static let startDate = "startDate"
    static let trainingPerDay = "trainingPerDay"
}
