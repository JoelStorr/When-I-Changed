//
//  DateHelper.swift
//  WhenIChanged
//
//  Created by Joel Storr on 10.11.23.
//

import Foundation

extension Calendar {
    // swiftlint:disable:next identifier_name
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
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }

    func getWeekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDay(rawValue: weekDay)!
    }
    
    func calculateSunday(day: WeekDay) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: -(day.rawValue - 1), to: Date()) else {
            return .now
        }
        return date
    }
    func calculateMonday(day: WeekDay) -> Date {
        guard let date = Calendar.current.date(byAdding: .day, value: -(day.rawValue - 2), to: Date()) else {
            return .now
        }
        return date
    }
}




class dateHolder: ObservableObject {
    @Published var date : Date = .now
}

