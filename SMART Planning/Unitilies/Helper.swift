//
//  Helper.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//

import UIKit

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


struct MeasurementUnit {
    let displayTitle: String
    let shortTitle: String
    
    static var measurementUnits = [MeasurementUnit(displayTitle: "pages", shortTitle: "p."),
                                   MeasurementUnit(displayTitle: "times", shortTitle: "t."),
                                   MeasurementUnit(displayTitle: "minutes", shortTitle: "min."),
                                   MeasurementUnit(displayTitle: "hours", shortTitle: "h."),
                                   MeasurementUnit(displayTitle: "dollars", shortTitle: "$"),
                                   MeasurementUnit(displayTitle: "kilograms", shortTitle: "kg."),
                                   MeasurementUnit(displayTitle: "kilometers", shortTitle: "km."),
                                   MeasurementUnit(displayTitle: "miles", shortTitle: "mi."),
                                   MeasurementUnit(displayTitle: "meditations", shortTitle: "medit."),
                                   MeasurementUnit(displayTitle: "pounds", shortTitle: "lb."),
                                   MeasurementUnit(displayTitle: "pictures", shortTitle: "pic."),
                                   MeasurementUnit(displayTitle: "courses", shortTitle: "co."),
                                   MeasurementUnit(displayTitle: "lessons", shortTitle: "les."),
                                   MeasurementUnit(displayTitle: "credits", shortTitle: "cr.")]
}
