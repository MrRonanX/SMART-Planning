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
    
    var icon: String {
        self.rawValue
    }
}

enum Illustrations: String {
    case becomingSmarter = "becomingSmarter"
    case enlightenment = "enlightenment"
    case buildingMuscles = "buildingMuscles"
    case gettingFit = "gettingFit"
    case idea = "ideaIllustration"
    case improveArt = "improveArt"
    case learningLanguage = "learningLanguage"
    case learningNewSkill = "learningNewSkill"
    case losingWeight = "losingWeight"
    case reading = "reading"
    case savingMoney = "savingMoney"
    case createGoal = "createGoal"
    
    var image: String {
        self.rawValue
    }
}

enum IntroIllustrations: String {
    case achievable = "achievable"
    case intro = "intro"
    case measurable = "measurable"
    case relevant = "relevant"
    case specific = "specific"
    case timely = "timely"
    
    var image: String {
        self.rawValue
    }
}
