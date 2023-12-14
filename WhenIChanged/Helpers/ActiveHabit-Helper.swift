//
//  ActiveHabit-Helper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 14.12.23.
//

import Foundation

enum UnitTypes: String, CaseIterable {
    case numberOfTimes = "Number of Times"
    case duration = "Duration"
    case weight = "Weight"
}

enum RepeatType: String, CaseIterable {
    case day, week, month
}

enum Field: Int, CaseIterable {
    case name, repeatAmount
}

enum Days: String, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

class WeekReminderData: ObservableObject {
    var id = UUID()
    @Published var day: Int =  0
    @Published var time: Date = .now
}

class DayReminderData: ObservableObject {
    var id = UUID()
    @Published var time: Date = .now
}
