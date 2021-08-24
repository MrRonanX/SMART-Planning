//
//  VerticalAlignment.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import SwiftUI

extension VerticalAlignment {
    struct CustomAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[VerticalAlignment.center]
        }
    }
    
    static let custom = VerticalAlignment(CustomAlignment.self)
}
