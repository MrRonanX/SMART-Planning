//
//  NotificationTime.swift
//  SMART Planning
//
//  SwiftData model for notification time
//

import Foundation
import SwiftData

@Model
final class NotificationTime {
    var hour: Int
    var minute: Int

    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}

