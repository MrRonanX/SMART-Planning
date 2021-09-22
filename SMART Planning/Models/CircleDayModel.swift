//
//  CircleDayModel.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/13/21.
//

import Foundation

struct DayCircleModel: Identifiable {
    var id = UUID()
    var title: String
    var longTitle: String
    var weekDay: Int
    var isSelected = true
}


struct Days {
    static let days = [DayCircleModel(title: "S", longTitle: "Sun", weekDay: 1),
                       DayCircleModel(title: "M", longTitle: "Mon", weekDay: 2),
                       DayCircleModel(title: "T", longTitle: "Tue", weekDay: 3),
                       DayCircleModel(title: "W", longTitle: "Wed", weekDay: 4),
                       DayCircleModel(title: "T", longTitle: "Thu", weekDay: 5),
                       DayCircleModel(title: "F", longTitle: "Fri", weekDay: 6),
                       DayCircleModel(title: "S", longTitle: "Sat", weekDay: 7)]
}


