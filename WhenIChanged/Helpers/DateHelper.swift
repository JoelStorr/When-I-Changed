//
//  DateHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.11.23.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date = .now) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        return numberOfDays.day!
    }
}

extension Date {

    enum WeekDay: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    func getWeekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDay(rawValue: weekDay)!
    }
}


