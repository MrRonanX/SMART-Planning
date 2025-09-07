//
//  DayChipModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import Foundation

struct DayChipModel: Identifiable {
    var id = UUID()
    var title: String
    var longTitle: String
    var weekDay: Int
    var isSelected = true
}

struct Days {
    static let days = [
        DayChipModel(title: "S", longTitle: "Sun", weekDay: 1),
        DayChipModel(title: "M", longTitle: "Mon", weekDay: 2),
        DayChipModel(title: "T", longTitle: "Tue", weekDay: 3),
        DayChipModel(title: "W", longTitle: "Wed", weekDay: 4),
        DayChipModel(title: "T", longTitle: "Thu", weekDay: 5),
        DayChipModel(title: "F", longTitle: "Fri", weekDay: 6),
        DayChipModel(title: "S", longTitle: "Sat", weekDay: 7)]
}


