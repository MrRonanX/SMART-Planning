//
//  GoalSpacing.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/14/21.
//

import SwiftUI

enum Spacing: CGFloat {
    case eightSteps = 15
    case sevenSteps = 20
    case sixSteps = 30
    case fiveSteps = 40
    case fourSteps = 50
    
    var lineLength: CGFloat {
        switch self {
        case .eightSteps, .fourSteps:
            return self.rawValue
        case .sevenSteps:
            return self.rawValue - 2
        case .sixSteps:
            return self.rawValue - 5
        case .fiveSteps:
            return self.rawValue - 10
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .eightSteps:
            return self.rawValue + 7
        case .sevenSteps:
            return self.rawValue + 5
        case .sixSteps:
            return self.rawValue + 1
        case .fiveSteps:
            return self.rawValue - 4
        case .fourSteps:
            return self.rawValue - 3
        }
    }
}
