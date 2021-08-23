//
//  Color + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import SwiftUI

extension Color {
    static let brandBlue        = Color("brandBlue")
    static let brandGrassGreen  = Color("brandGrassGreen")
    static let brandMagenta     = Color("brandMagenta")
    static let brandOceanBlue   = Color("brandOceanBlue")
    static let brandPink        = Color("brandPink")
    static let brandPurple      = Color("brandPurple")
    static let brandRed         = Color("brandRed")
    static let brandSkyBlue     = Color("brandSkyBlue")
    static let brandTurquoise   = Color("brandTurquoise")
    
    static let standartBlue     = Color.blue
    static let standartYellow   = Color.yellow
    static let standartGreen    = Color.green
    static let standartPurple   = Color.purple
    static let standartRed      = Color.red
    static let standartPink     = Color.pink
    static let standartOrange   = Color.orange
}


extension UIColor {
    static var rowBackground: UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .unspecified:
                return .secondarySystemBackground
            case .light:
                return .secondarySystemBackground
            case .dark:
                return .systemBackground
            @unknown default:
                return .secondarySystemBackground
            }
        }
    }
    
    static var iconBackground: UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .unspecified:
                return .systemBackground
            case .light:
                return .systemBackground
            case .dark:
                return .secondarySystemBackground
            @unknown default:
                return .systemBackground
            }
        }
    }
    
    static var tabButtonColor: UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .unspecified:
                return .tertiarySystemBackground
            case .light:
                return .tertiarySystemBackground
            case .dark:
                return .systemGray
            @unknown default:
                return .tertiarySystemBackground
            }
        }
    }
    
    static var formTabButtonColor: UIColor {
        return UIColor { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .unspecified:
                return .systemGray6
            case .light:
                return .systemGray6
            case .dark:
                return .systemGray3
            @unknown default:
                return .systemGray6
            }
        }
    }
}
