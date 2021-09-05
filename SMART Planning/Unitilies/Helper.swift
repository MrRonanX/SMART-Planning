//
//  Helper.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//

import UIKit

enum Spacing: CGFloat {
    case sevenSteps = 25
    case sixSteps   = 30
    case fiveSteps  = 40
    case fourSteps  = 50
    case threeSteps = 60
    
    var lineLength: CGFloat {
        switch self {
        case .fourSteps:
            return self.rawValue
        case .sevenSteps:
            return self.rawValue - 5
        case .sixSteps:
            return self.rawValue - 5
        case .fiveSteps:
            return self.rawValue - 10
        case .threeSteps:
            return self.rawValue
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .sevenSteps:
            return self.rawValue + 3
        case .sixSteps:
            return self.rawValue + 1
        case .fiveSteps:
            return self.rawValue - 4
        case .fourSteps:
            return self.rawValue - 3
        case .threeSteps:
            return self.rawValue - 5

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
                                   MeasurementUnit(displayTitle: "meditations", shortTitle: "m."),
                                   MeasurementUnit(displayTitle: "pounds", shortTitle: "lb."),
                                   MeasurementUnit(displayTitle: "pictures", shortTitle: "pic."),
                                   MeasurementUnit(displayTitle: "courses", shortTitle: "c."),
                                   MeasurementUnit(displayTitle: "lessons", shortTitle: "l."),
                                   MeasurementUnit(displayTitle: "credits", shortTitle: "cr.")]
}

enum DeviceTypes {
    enum ScreenSize {
        static let width         = UIScreen.main.bounds.size.width
        static let height        = UIScreen.main.bounds.size.height
        static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    }
    
    static let idiom             = UIDevice.current.userInterfaceIdiom
    static let nativeScale       = UIScreen.main.nativeScale
    static let scale             = UIScreen.main.scale

    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
}

