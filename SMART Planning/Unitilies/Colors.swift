//
//  Colors.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/14/21.
//

import Foundation

enum Colors: String, CaseIterable {
    case brandBlue          = "brandBlue"
    case brandGrassGreen    = "brandGrassGreen"
    case brandMagenta       = "brandMagenta"
    case brandOceanBlue     = "brandOceanBlue"
    case brandPink          = "brandPink"
    case brandPurple        = "brandPurple"
    case brandRed           = "brandRed"
    case brandSkyBlue       = "brandSkyBlue"
    case brandTurquoise     = "brandTurquoise"
    case brandAmber         = "brandAmber"
    case brandCelery        = "brandCelery"
    case brandCoral         = "brandCoral"
    case brandOrange        = "brandOrange"
    case brandTan           = "brandTan"
    
    var color: String {
        self.rawValue
    }
}


