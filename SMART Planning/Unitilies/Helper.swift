//
//  Helper.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/27/21.
//

import UIKit

@MainActor
enum Spacing: CGFloat {
    case sevenSteps = 25
    case sixSteps   = 30
    case fiveSteps  = 40
    case fourSteps  = 50
    
    var value: CGFloat {
        DeviceTypes.isiPhone8Standard ? self.rawValue - 5 : self.rawValue
    }
    
    var pictureSize: CGFloat {
        switch self {
        case .sevenSteps:
            return value + 5
        case .sixSteps:
            return DeviceTypes.isiPhone8Standard ? value + 5 : value
        case .fiveSteps:
            return 35
        case .fourSteps:
            return 35
        }
    }
    
    var lineLength: CGFloat {
        switch self {
        case .fourSteps:
            return value - 4
        case .sevenSteps, .sixSteps:
            return value - 5
        case .fiveSteps:
            return value - 8
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .sevenSteps:
            return DeviceTypes.isiPhone8Standard ? value + 5 : value + 3
        case .sixSteps:
            return DeviceTypes.isiPhone8Standard ? value + 3 : value + 1
        case .fiveSteps:
            return DeviceTypes.isiPhone8Standard ? value - 2 : value - 4
        case .fourSteps:
            return DeviceTypes.isiPhone8Standard ? value - 4 : value - 3
        }
    }
}


struct MeasurementUnit {
    let displayTitle: String
    let shortTitle: String

    static let measurementUnits: [MeasurementUnit] = [MeasurementUnit(displayTitle: "pages", shortTitle: "p."),
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

@MainActor
enum DeviceTypes {
    enum ScreenSize {
        @MainActor static var width: CGFloat { UIScreen.main.bounds.size.width }
        @MainActor static var height: CGFloat { UIScreen.main.bounds.size.height }
        @MainActor static var maxLength: CGFloat { max(ScreenSize.width, ScreenSize.height) }
    }
    
    @MainActor static var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @MainActor static var nativeScale: CGFloat { UIScreen.main.nativeScale }
    @MainActor static var scale: CGFloat { UIScreen.main.scale }

    @MainActor static var isiPhone8Standard: Bool { idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale }
}
