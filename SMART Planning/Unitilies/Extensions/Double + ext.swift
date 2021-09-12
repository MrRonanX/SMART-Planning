//
//  Double + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/30/21.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
